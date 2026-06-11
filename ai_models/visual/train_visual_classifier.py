
import os
import shutil
import subprocess
import cv2
import json
import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np
from pathlib import Path
from torch.utils.data import Dataset, DataLoader, WeightedRandomSampler
from torch.optim.swa_utils import AveragedModel, update_bn
from torchvision import models, transforms
from PIL import Image, ImageFile

ImageFile.LOAD_TRUNCATED_IMAGES = True

LABELS = [
    "normal",
    "weapon_detected",
    "explosion",
    "car_crash",
    "violence",
    "person_down",
    "intrusion_detected",
]

IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".bmp", ".webp", ".tiff", ".tif"}
NUM_CLASSES = len(LABELS)
LABEL_TO_IDX = {label: idx for idx, label in enumerate(LABELS)}
IDX_TO_LABEL = {idx: label for idx, label in enumerate(LABELS)}

class FrameDataset(Dataset):
    """Dataset of (image_path, label_idx) pairs with on-the-fly transforms."""

    def __init__(self, samples: list, transform=None,
                 gentle_transform=None, gentle_classes=None):
        self.samples = samples
        self.transform = transform
        self.gentle_transform = gentle_transform
        self.gentle_classes = gentle_classes or set()

    def __len__(self):
        return len(self.samples)

    def __getitem__(self, idx):
        item = self.samples[idx]
        try:
            img = Image.open(item["path"]).convert("RGB")
        except (OSError, IOError):
            img = Image.new("RGB", (224, 224), (128, 128, 128))
        if self.gentle_transform and item["label_idx"] in self.gentle_classes:
            img = self.gentle_transform(img)
        elif self.transform:
            img = self.transform(img)
        label = torch.zeros(NUM_CLASSES, dtype=torch.float32)
        label[item["label_idx"]] = 1.0
        return img, label

IMAGENET_MEAN = [0.485, 0.456, 0.406]
IMAGENET_STD  = [0.229, 0.224, 0.225]

def make_train_transform(img_size=224):
    """Strong augmentation with configurable resolution."""
    resize_to = img_size + 32
    return transforms.Compose([
        transforms.Resize((resize_to, resize_to)),
        transforms.RandomResizedCrop(img_size, scale=(0.6, 1.0)),
        transforms.RandomHorizontalFlip(),
        transforms.RandomRotation(15),
        transforms.ColorJitter(brightness=0.3, contrast=0.3, saturation=0.2, hue=0.05),
        transforms.RandomGrayscale(p=0.1),
        transforms.RandomPerspective(distortion_scale=0.2, p=0.3),
        transforms.RandomApply(
            [transforms.GaussianBlur(kernel_size=3, sigma=(0.1, 2.0))], p=0.2
        ),
        transforms.ToTensor(),
        transforms.Normalize(IMAGENET_MEAN, IMAGENET_STD),
        transforms.RandomErasing(p=0.25, scale=(0.02, 0.25)),
    ])

def make_val_transform(img_size=224):
    """Deterministic validation transform with configurable resolution."""
    resize_to = img_size + 32
    return transforms.Compose([
        transforms.Resize((resize_to, resize_to)),
        transforms.CenterCrop(img_size),
        transforms.ToTensor(),
        transforms.Normalize(IMAGENET_MEAN, IMAGENET_STD),
    ])

def make_train_transform_gentle(img_size=224):
    """Gentler augmentation for small-object classes like weapons.

    Avoids RandomPerspective (distorts small shapes) and aggressive crops
    that might cut weapons out of frame.  Keeps mild RandomErasing
    (low p, small scale) for regularisation without masking entire weapons.
    """
    resize_to = img_size + 32
    return transforms.Compose([
        transforms.Resize((resize_to, resize_to)),
        transforms.RandomResizedCrop(img_size, scale=(0.75, 1.0)),
        transforms.RandomHorizontalFlip(),
        transforms.RandomRotation(10),
        transforms.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.15, hue=0.03),
        transforms.RandomGrayscale(p=0.05),
        transforms.ToTensor(),
        transforms.Normalize(IMAGENET_MEAN, IMAGENET_STD),
        transforms.RandomErasing(p=0.1, scale=(0.02, 0.12)),
    ])

train_transform = make_train_transform(224)
val_transform = make_val_transform(224)

def mixup_data(x, y, alpha=0.4):
    """Apply MixUp: blend two random images and their multi-hot label vectors."""
    if alpha > 0:
        lam = np.random.beta(alpha, alpha)
    else:
        lam = 1.0

    lam = max(lam, 1.0 - lam)

    batch_size = x.size(0)
    index = torch.randperm(batch_size).to(x.device)

    mixed_x = lam * x + (1.0 - lam) * x[index]
    mixed_y = lam * y + (1.0 - lam) * y[index]
    return mixed_x, mixed_y, lam

class FocalBCELoss(nn.Module):
    """Focal loss with BCE for multi-label classification.

    Uses pos_weight to handle class imbalance — higher weights for
    rare classes increase the loss when the model misses a positive.
    """
    def __init__(self, pos_weight=None, gamma=2.0, label_smoothing=0.0):
        super().__init__()
        self.pos_weight = pos_weight
        self.gamma = gamma
        self.label_smoothing = label_smoothing

    def forward(self, inputs, targets):
        if self.label_smoothing > 0:
            targets = targets * (1 - self.label_smoothing) + 0.5 * self.label_smoothing
        bce = nn.functional.binary_cross_entropy_with_logits(
            inputs, targets,
            pos_weight=self.pos_weight,
            reduction='none',
        )
        pt = torch.exp(-bce)
        return ((1 - pt) ** self.gamma * bce).mean()

def cutmix_data(x, y, alpha=1.0):
    """CutMix: paste a random rectangular patch from one image onto another.

    Complements MixUp — MixUp blends globally (good for textures), CutMix
    blends locally (good for object shapes like weapons, fallen persons).
    Together they cover both types of surveillance cues.
    """
    lam = np.random.beta(alpha, alpha) if alpha > 0 else 1.0
    batch_size, _, H, W = x.shape
    index = torch.randperm(batch_size).to(x.device)

    cut_rat = np.sqrt(1.0 - lam)
    cut_w = int(W * cut_rat)
    cut_h = int(H * cut_rat)
    cx = np.random.randint(W)
    cy = np.random.randint(H)
    bbx1 = np.clip(cx - cut_w // 2, 0, W)
    bby1 = np.clip(cy - cut_h // 2, 0, H)
    bbx2 = np.clip(cx + cut_w // 2, 0, W)
    bby2 = np.clip(cy + cut_h // 2, 0, H)

    x = x.clone()
    x[:, :, bby1:bby2, bbx1:bbx2] = x[index, :, bby1:bby2, bbx1:bbx2]
    lam = 1.0 - (bbx2 - bbx1) * (bby2 - bby1) / (W * H)
    mixed_y = lam * y + (1.0 - lam) * y[index]
    return x, mixed_y, lam

def extract_and_split_dataset(
    source_path="simulation/datasets/video",
    images_path="simulation/datasets/image",
    output_path="ai_models/visual/classifier_frames",
    frames_per_video=6,
    max_images_per_class=800,
    test_size=0.2,
    random_state=42
):
    """
    Extract frames from videos and gather images, performing a strict video-level
    and image-level split first to prevent any data leakage.
    """
    np.random.seed(random_state)
    import random
    random.seed(random_state)

    print("\n📸 Processing and splitting dataset (strict video/image level split)...")
    print("-" * 70)

    if os.path.exists(output_path):
        print("Cleaning stale classifier_frames directory...")
        for root, dirs, files in os.walk(output_path):
            for f in files:
                if f == '.DS_Store' or f.startswith('._'):
                    os.remove(os.path.join(root, f))
        shutil.rmtree(output_path, ignore_errors=True)
        if os.path.exists(output_path):
            subprocess.run(["rm", "-rf", output_path], check=True)
    os.makedirs(output_path, exist_ok=True)

    train_samples = []
    val_samples = []

    class_videos = {}
    for label in LABELS:
        folder = os.path.join(source_path, label)
        if os.path.exists(folder):
            videos = []
            for ext in ["*.mp4", "*.avi", "*.mov"]:
                videos.extend(list(Path(folder).glob(ext)))
            if videos:
                class_videos[label] = sorted(videos)

    max_videos = max(len(v) for v in class_videos.values()) if class_videos else 0
    target_frames = max_videos * frames_per_video

    MAX_FPV = {"weapon_detected": 22}

    for label in LABELS:
        label_idx = LABEL_TO_IDX[label]

        if label in class_videos:
            videos = class_videos[label]
            np.random.shuffle(videos)

            split_idx = int(len(videos) * (1.0 - test_size))
            train_videos = videos[:split_idx]
            val_videos = videos[split_idx:]

            if train_videos:
                fpv_train = max(1, int(np.ceil(target_frames / len(videos))))
                fpv_train = min(fpv_train, MAX_FPV.get(label, fpv_train))
                train_dir = os.path.join(output_path, "train", label)
                os.makedirs(train_dir, exist_ok=True)
                for video_path in train_videos:
                    cap = cv2.VideoCapture(str(video_path))
                    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
                    if total_frames <= 0:
                        cap.release()
                        continue
                    num_to_extract = min(fpv_train, total_frames)
                    frame_indices = np.linspace(0, total_frames - 1, num_to_extract, dtype=int)
                    for idx in frame_indices:
                        cap.set(cv2.CAP_PROP_POS_FRAMES, idx)
                        ret, frame = cap.read()
                        if not ret:
                            continue
                        fname = f"train_{label}_{video_path.stem}_f{idx}.jpg"
                        fpath = os.path.join(train_dir, fname)
                        cv2.imwrite(fpath, frame)
                        train_samples.append({
                            "path": fpath,
                            "label_idx": label_idx,
                            "label": label,
                        })
                    cap.release()

            if val_videos:
                fpv_val = max(1, int(np.ceil(target_frames / len(videos))))
                fpv_val = min(fpv_val, MAX_FPV.get(label, fpv_val))
                val_dir = os.path.join(output_path, "val", label)
                os.makedirs(val_dir, exist_ok=True)
                for video_path in val_videos:
                    cap = cv2.VideoCapture(str(video_path))
                    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
                    if total_frames <= 0:
                        cap.release()
                        continue
                    num_to_extract = min(fpv_val, total_frames)
                    frame_indices = np.linspace(0, total_frames - 1, num_to_extract, dtype=int)
                    for idx in frame_indices:
                        cap.set(cv2.CAP_PROP_POS_FRAMES, idx)
                        ret, frame = cap.read()
                        if not ret:
                            continue
                        fname = f"val_{label}_{video_path.stem}_f{idx}.jpg"
                        fpath = os.path.join(val_dir, fname)
                        cv2.imwrite(fpath, frame)
                        val_samples.append({
                            "path": fpath,
                            "label_idx": label_idx,
                            "label": label,
                        })
                    cap.release()

        img_folder = os.path.join(images_path, label)
        if os.path.exists(img_folder):
            images = [
                p for p in Path(img_folder).iterdir()
                if p.suffix.lower() in IMAGE_EXTENSIONS
            ]
            if images:
                images = sorted(images)
                if len(images) > max_images_per_class:
                    np.random.shuffle(images)
                    images = images[:max_images_per_class]
                else:
                    np.random.shuffle(images)

                split_idx = int(len(images) * (1.0 - test_size))
                train_images = images[:split_idx]
                val_images = images[split_idx:]

                for img_path in train_images:
                    train_samples.append({
                        "path": str(img_path),
                        "label_idx": label_idx,
                        "label": label,
                    })
                for img_path in val_images:
                    val_samples.append({
                        "path": str(img_path),
                        "label_idx": label_idx,
                        "label": label,
                    })

    print("\nDataset generation and split complete!")
    print("-" * 70)
    for label in LABELS:
        tr_c = sum(1 for s in train_samples if s["label"] == label)
        va_c = sum(1 for s in val_samples if s["label"] == label)
        print(f"✓ {label:<25} Train: {tr_c:>4} | Val: {va_c:>4}")

    print(f"\nTotal Train samples: {len(train_samples)}")
    print(f"Total Val samples:   {len(val_samples)}")

    return train_samples, val_samples

def build_model(num_classes: int, freeze_backbone: bool = True):
    """EfficientNet-V2-S with a regularised classification head.

    EfficientNet-V2-S achieves 84.2% top-1 on ImageNet vs 76.1% for ResNet50,
    giving much richer pretrained features for fine-grained surveillance scenes.
    """
    model = models.efficientnet_v2_s(weights=models.EfficientNet_V2_S_Weights.IMAGENET1K_V1)

    if freeze_backbone:
        for param in model.parameters():
            param.requires_grad = False

    in_features = model.classifier[1].in_features
    model.classifier = nn.Sequential(
        nn.Dropout(p=0.4),
        nn.Linear(in_features, 768),
        nn.BatchNorm1d(768),
        nn.GELU(),
        nn.Dropout(p=0.3),
        nn.Linear(768, 384),
        nn.BatchNorm1d(384),
        nn.GELU(),
        nn.Dropout(p=0.2),
        nn.Linear(384, num_classes),
    )

    return model

def unfreeze_backbone(model, include_3: bool = False):
    """Unfreeze features.4-6 (and optionally features.3) plus the classifier head."""
    layers = [3, 4, 5, 6] if include_3 else [4, 5, 6]
    for name, param in model.named_parameters():
        if any(f"features.{i}" in name for i in layers) or "classifier" in name:
            param.requires_grad = True
        else:
            param.requires_grad = False

def train(
    source_path="simulation/datasets/video",
    images_path="simulation/datasets/image",
    frames_path="ai_models/visual/classifier_frames",
    save_path="ai_models/visual/saved_model",
    total_epochs=80,
    unfreeze_epoch=15,
    batch_size=32,
    lr_head=1e-3,
    lr_backbone=5e-5,
    lr_head_ft=4e-5,
    weight_decay=0.02,
    mixup_alpha=0.3,
):
    print("\n" + "=" * 60)
    print("   EfficientNet-V2-S — SURVEILLANCE SCENE CLASSIFICATION")
    print("=" * 60)

    device = torch.device(
        "mps" if torch.backends.mps.is_available()
        else "cuda" if torch.cuda.is_available()
        else "cpu"
    )
    print(f"\nUsing device: {device}")

    train_samples, val_samples = extract_and_split_dataset(
        source_path, images_path, frames_path,
        frames_per_video=10, max_images_per_class=800
    )

    if not train_samples:
        print("\nNo training data found — add videos to simulation/datasets/video/")
        print("or images to simulation/datasets/image/<label>/")
        return

    train_labels = [s["label_idx"] for s in train_samples]
    train_counts = np.bincount(train_labels, minlength=NUM_CLASSES)

    class_weights = [1.0 / max(train_counts[i], 1) for i in range(NUM_CLASSES)]
    weapon_idx = LABEL_TO_IDX["weapon_detected"]
    class_weights[weapon_idx] *= 3.0
    sample_weights = [class_weights[s["label_idx"]] for s in train_samples]
    sampler = WeightedRandomSampler(
        weights=sample_weights,
        num_samples=len(train_samples),
        replacement=True,
    )

    weapon_classes = {LABEL_TO_IDX["weapon_detected"]}
    curr_train_tf = make_train_transform(224)
    curr_train_gentle = make_train_transform_gentle(224)
    curr_val_tf = make_val_transform(224)
    train_loader = DataLoader(
        FrameDataset(train_samples, transform=curr_train_tf,
                     gentle_transform=curr_train_gentle,
                     gentle_classes=weapon_classes),
        batch_size=batch_size,
        sampler=sampler,
        num_workers=0,
    )
    val_loader = DataLoader(
        FrameDataset(val_samples, transform=curr_val_tf),
        batch_size=batch_size,
        shuffle=False,
        num_workers=0,
    )

    model = build_model(NUM_CLASSES, freeze_backbone=True).to(device)

    median_count = np.median(train_counts[train_counts > 0])
    loss_weights = torch.tensor([
        np.sqrt(median_count / max(train_counts[i], 1))
        for i in range(NUM_CLASSES)
    ], dtype=torch.float32).to(device)
    loss_weights[weapon_idx] *= 3.0
    print(f"\n📊 Class weights for loss:")
    for i, label in enumerate(LABELS):
        print(f"   {label:<25} count={train_counts[i]:>5}  weight={loss_weights[i]:.2f}")

    criterion = FocalBCELoss(
        pos_weight=loss_weights,
        gamma=1.5,
        label_smoothing=0.0,
    )

    optimizer = optim.AdamW(
        filter(lambda p: p.requires_grad, model.parameters()),
        lr=lr_head,
        weight_decay=weight_decay,
    )
    scheduler = optim.lr_scheduler.CosineAnnealingLR(
        optimizer, T_max=unfreeze_epoch, eta_min=1e-5
    )

    best_val_acc = 0.0
    patience_counter = 0
    patience_limit = 20
    swa_model = None
    swa_start = 50

    print(f"\n🚀 Starting training for {total_epochs} epochs...")
    print(f"   Phase 1 (epochs 1–{unfreeze_epoch}): Train classifier head only (224px)")
    print(f"   Phase 2 (epochs {unfreeze_epoch+1}+): Fine-tune features.4-6+head (300px, MixUp α={mixup_alpha})")
    print(f"   Scheduler: CosineAnnealingWarmRestarts (T_0=10, T_mult=2)")
    print(f"   SWA averaging starts at epoch {swa_start+1}")
    print(f"   Regularisation: weight_decay={weight_decay}, dropout=0.4/0.3/0.2")
    print("=" * 60)

    for epoch in range(total_epochs):
        if epoch == unfreeze_epoch:
            print(f"\n🔓 Unfreezing features.4-6 at epoch {epoch + 1}...")
            unfreeze_backbone(model, include_3=False)

            deep_params = [
                p for n, p in model.named_parameters()
                if "features.4" in n and p.requires_grad
            ]
            mid_params = [
                p for n, p in model.named_parameters()
                if ("features.5" in n or "features.6" in n) and p.requires_grad
            ]
            head_params = [
                p for n, p in model.named_parameters()
                if "classifier" in n and p.requires_grad
            ]
            optimizer = optim.AdamW([
                {"params": deep_params, "lr": lr_backbone * 0.2},
                {"params": mid_params,  "lr": lr_backbone},
                {"params": head_params, "lr": lr_head_ft},
            ], weight_decay=weight_decay)

            scheduler = optim.lr_scheduler.CosineAnnealingWarmRestarts(
                optimizer, T_0=10, T_mult=2, eta_min=1e-6
            )
            patience_counter = 0

            print(f"   📐 Resolution: 224px → 300px")
            curr_train_tf = make_train_transform(300)
            curr_train_gentle = make_train_transform_gentle(300)
            curr_val_tf = make_val_transform(300)
            train_loader = DataLoader(
                FrameDataset(train_samples, transform=curr_train_tf,
                             gentle_transform=curr_train_gentle,
                             gentle_classes=weapon_classes),
                batch_size=batch_size,
                sampler=sampler,
                num_workers=0,
            )
            val_loader = DataLoader(
                FrameDataset(val_samples, transform=curr_val_tf),
                batch_size=batch_size,
                shuffle=False,
                num_workers=0,
            )

        if epoch == swa_start:
            print(f"\n📊 Starting SWA weight averaging at epoch {epoch + 1}...")
            swa_model = AveragedModel(model).to(device)

        model.train()
        train_loss = 0.0
        train_correct = 0
        train_total = 0

        for images, labels in train_loader:
            images = images.to(device)
            labels = labels.to(device)

            if epoch >= unfreeze_epoch:
                has_weapons = (labels[:, weapon_idx] > 0.5).any()
                if has_weapons:
                    mixed_images, mixed_labels, lam = images, labels, 1.0
                elif np.random.rand() < 0.5:
                    mixed_images, mixed_labels, lam = mixup_data(images, labels, alpha=mixup_alpha)
                else:
                    mixed_images, mixed_labels, lam = cutmix_data(images, labels, alpha=mixup_alpha)
            else:
                mixed_images, mixed_labels, lam = images, labels, 1.0

            optimizer.zero_grad()
            outputs = model(mixed_images)
            loss = criterion(outputs, mixed_labels)
            loss.backward()
            torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)
            optimizer.step()

            train_loss += loss.item()
            with torch.no_grad():
                preds = torch.sigmoid(outputs)
            _, predicted = preds.max(1)
            _, true_class = mixed_labels.max(1)
            train_total += labels.size(0)
            train_correct += predicted.eq(true_class).sum().item()

        train_acc = 100.0 * train_correct / train_total

        if swa_model is not None:
            swa_model.update_parameters(model)

        model.eval()
        val_loss = 0.0
        val_correct = 0
        val_total = 0
        val_preds = []
        val_targets = []

        with torch.no_grad():
            for images, labels in val_loader:
                images = images.to(device)
                labels = labels.to(device)

                outputs = model(images)
                loss = criterion(outputs, labels)

                val_loss += loss.item()
                preds = torch.sigmoid(outputs)
                _, predicted = preds.max(1)
                _, true_class = labels.max(1)
                val_total += labels.size(0)
                val_correct += predicted.eq(true_class).sum().item()
                val_preds.extend(predicted.cpu().numpy())
                val_targets.extend(true_class.cpu().numpy())

        val_acc = 100.0 * val_correct / val_total
        avg_val_loss = val_loss / len(val_loader)

        if (epoch + 1) % 5 == 0 or epoch == unfreeze_epoch - 1:
            preds_np   = np.array(val_preds)
            targets_np = np.array(val_targets)
            print(f"\n  Per-class val accuracy (epoch {epoch + 1}):")
            for i, label in enumerate(LABELS):
                mask = targets_np == i
                if mask.sum() > 0:
                    acc = 100.0 * (preds_np[mask] == i).sum() / mask.sum()
                    print(f"    {label:<25} {acc:5.1f}%  ({int(mask.sum())} samples)")
            print()

        if isinstance(scheduler, optim.lr_scheduler.ReduceLROnPlateau):
            scheduler.step(avg_val_loss)
        else:
            scheduler.step()

        current_lr = optimizer.param_groups[0]["lr"]
        phase = "HEAD" if epoch < unfreeze_epoch else "FINE"

        print(
            f"Epoch {epoch+1:>3}/{total_epochs} [{phase}] | "
            f"Train loss: {train_loss/len(train_loader):.4f} | "
            f"Train acc: {train_acc:.1f}% | "
            f"Val loss: {avg_val_loss:.4f} | "
            f"Val acc: {val_acc:.1f}% | "
            f"LR: {current_lr:.6f}"
        )

        if val_acc > best_val_acc:
            best_val_acc = val_acc
            patience_counter = 0
            os.makedirs(save_path, exist_ok=True)
            torch.save(model.state_dict(), f"{save_path}/best_classifier.pth")
            with open(f"{save_path}/classifier_labels.json", "w") as f:
                json.dump(IDX_TO_LABEL, f)
            print(f"  ✓ Best model saved — val acc: {val_acc:.1f}%")
        else:
            if swa_model is None:
                patience_counter += 1
            if patience_counter >= patience_limit:
                print(f"\n⏹ Early stopping at epoch {epoch + 1} (no improvement for {patience_limit} epochs)")
                break

    if swa_model is not None:
        print("\n📊 Finalizing SWA model (updating batch norm statistics)...")
        update_bn(train_loader, swa_model, device=device)

        swa_model.eval()
        swa_correct = 0
        swa_total = 0
        swa_preds = []
        swa_targets = []
        with torch.no_grad():
            for images, labels in val_loader:
                images, labels = images.to(device), labels.to(device)
                outputs = swa_model(images)
                preds = torch.sigmoid(outputs)
                _, predicted = preds.max(1)
                _, true_class = labels.max(1)
                swa_total += labels.size(0)
                swa_correct += predicted.eq(true_class).sum().item()
                swa_preds.extend(predicted.cpu().numpy())
                swa_targets.extend(true_class.cpu().numpy())
        swa_acc = 100.0 * swa_correct / swa_total
        print(f"   SWA val accuracy: {swa_acc:.1f}% (best regular: {best_val_acc:.1f}%)")

        preds_np = np.array(swa_preds)
        targets_np = np.array(swa_targets)
        print(f"\n  Per-class SWA val accuracy:")
        for i, label in enumerate(LABELS):
            mask = targets_np == i
            if mask.sum() > 0:
                acc = 100.0 * (preds_np[mask] == i).sum() / mask.sum()
                print(f"    {label:<25} {acc:5.1f}%  ({int(mask.sum())} samples)")

        if swa_acc > best_val_acc:
            best_val_acc = swa_acc
            torch.save(swa_model.module.state_dict(), f"{save_path}/best_classifier.pth")
            print(f"\n   ✓ SWA model saved — val acc: {swa_acc:.1f}%")
        else:
            print(f"\n   Regular model was better — keeping best checkpoint")

    print("=" * 60)
    print(f"Training complete!")
    print(f"Best validation accuracy: {best_val_acc:.1f}%")
    print(f"Model saved to: {save_path}/best_classifier.pth")

    return best_val_acc

def evaluate(
    source_path="simulation/datasets/video",
    save_path="ai_models/visual/saved_model",
):
    model_path = f"{save_path}/best_classifier.pth"
    if not os.path.exists(model_path):
        print("No classifier model found. Run training first.")
        return

    device = torch.device(
        "mps" if torch.backends.mps.is_available()
        else "cuda" if torch.cuda.is_available()
        else "cpu"
    )

    model = build_model(NUM_CLASSES, freeze_backbone=False).to(device)
    model.load_state_dict(torch.load(model_path, map_location=device))
    model.eval()

    print("\nEvaluating classifier on sample frames...")
    print("-" * 50)

    correct = 0
    total = 0

    for label in LABELS:
        folder = os.path.join(source_path, label)
        if not os.path.exists(folder):
            continue

        video_files = list(Path(folder).glob("*.mp4"))
        if not video_files:
            continue

        cap = cv2.VideoCapture(str(video_files[0]))
        ret, frame = cap.read()
        cap.release()
        if not ret:
            continue

        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        img = Image.fromarray(frame_rgb)
        tensor = val_transform(img).unsqueeze(0).to(device)

        with torch.no_grad():
            output = model(tensor)
            probs = torch.sigmoid(output)
            confidence, pred_idx = probs.max(1)
            predicted = LABELS[pred_idx.item()]

        is_correct = predicted == label
        correct += int(is_correct)
        total += 1
        symbol = "✓" if is_correct else "✗"
        print(f"{symbol} True: {label:<25} Predicted: {predicted:<25} Conf: {confidence.item():.2f}")

    if total > 0:
        accuracy = 100.0 * correct / total
        print("-" * 50)
        print(f"Accuracy: {accuracy:.1f}% ({correct}/{total})")

if __name__ == "__main__":
    train()
    evaluate()
