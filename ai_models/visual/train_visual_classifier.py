
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
from torchvision import models, transforms
from PIL import Image, ImageFile

ImageFile.LOAD_TRUNCATED_IMAGES = True


# ──────────────────────────────────────────────
#  Constants
# ──────────────────────────────────────────────

LABELS = [
    "normal",
    "weapon_detected",
    "explosion",
    "car_crash",
    "violence",
    "robbery",
    "person_down",
    "intrusion_detected",
    # NOTE: suspicious_package is NOT a classifier class — it is detected
    # by the fusion engine's abandoned-object tracking (COCO bag/suitcase
    # detection + stationary-time + owner-distance logic).
]

IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".bmp", ".webp", ".tiff", ".tif"}
NUM_CLASSES = len(LABELS)
LABEL_TO_IDX = {label: idx for idx, label in enumerate(LABELS)}
IDX_TO_LABEL = {idx: label for idx, label in enumerate(LABELS)}


# ──────────────────────────────────────────────
#  Dataset
# ──────────────────────────────────────────────

class FrameDataset(Dataset):
    """Dataset of (image_path, label_idx) pairs with on-the-fly transforms."""

    def __init__(self, samples: list, transform=None):
        self.samples = samples      # list of {"path": str, "label_idx": int}
        self.transform = transform

    def __len__(self):
        return len(self.samples)

    def __getitem__(self, idx):
        item = self.samples[idx]
        try:
            img = Image.open(item["path"]).convert("RGB")
        except (OSError, IOError):
            # Return a grey placeholder if the file is corrupt/truncated
            img = Image.new("RGB", (224, 224), (128, 128, 128))
        if self.transform:
            img = self.transform(img)
        label = torch.tensor(item["label_idx"], dtype=torch.long)
        return img, label


# ──────────────────────────────────────────────
#  Transforms
# ──────────────────────────────────────────────

IMAGENET_MEAN = [0.485, 0.456, 0.406]
IMAGENET_STD  = [0.229, 0.224, 0.225]

# Strong augmentation — each view of the same frame looks different,
# making memorisation of specific frames much harder.
train_transform = transforms.Compose([
    transforms.Resize((256, 256)),
    transforms.RandomResizedCrop(224, scale=(0.6, 1.0)),
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

val_transform = transforms.Compose([
    transforms.Resize((256, 256)),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(IMAGENET_MEAN, IMAGENET_STD),
])


# ──────────────────────────────────────────────
#  MixUp — the key anti-overfitting technique
# ──────────────────────────────────────────────
#
#  MixUp blends two random training images and their labels:
#    x_mixed = λ·x_i + (1−λ)·x_j
#    loss    = λ·L(pred, y_i) + (1−λ)·L(pred, y_j)
#
#  This prevents the model from memorising individual frames because
#  it never sees a "pure" training example — only blends.  The model
#  must learn shared class features (fire texture, weapon shape, etc.)
#  instead of scene-specific details (backgrounds, camera angles).

def mixup_data(x, y, alpha=0.4):
    """Apply MixUp: blend two random images with a Beta-distributed weight."""
    if alpha > 0:
        lam = np.random.beta(alpha, alpha)
    else:
        lam = 1.0

    # Ensure the dominant image contributes >= 50% (for cleaner accuracy tracking)
    lam = max(lam, 1.0 - lam)

    batch_size = x.size(0)
    index = torch.randperm(batch_size).to(x.device)

    mixed_x = lam * x + (1.0 - lam) * x[index]
    y_a, y_b = y, y[index]
    return mixed_x, y_a, y_b, lam


def mixup_criterion(criterion, pred, y_a, y_b, lam):
    """Weighted loss for MixUp blended labels."""
    return lam * criterion(pred, y_a) + (1.0 - lam) * criterion(pred, y_b)


class FocalLoss(nn.Module):
    def __init__(self, alpha=None, gamma=2.0, label_smoothing=0.1):
        super().__init__()
        self.alpha = alpha
        self.gamma = gamma
        self.label_smoothing = label_smoothing

    def forward(self, inputs, targets):
        ce = nn.functional.cross_entropy(
            inputs, targets,
            weight=self.alpha,
            label_smoothing=self.label_smoothing,
            reduction='none',
        )
        pt = torch.exp(-ce)
        return ((1 - pt) ** self.gamma * ce).mean()


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
    return x, y, y[index], lam


# ──────────────────────────────────────────────
#  Frame extraction
# ──────────────────────────────────────────────

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

    # Clean stale frames — handle macOS .DS_Store / resource fork files
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

    # --- Part 1: Gather video files and split at the video level ---
    class_videos = {}
    for label in LABELS:
        folder = os.path.join(source_path, label)
        if os.path.exists(folder):
            videos = []
            for ext in ["*.mp4", "*.avi", "*.mov"]:
                videos.extend(list(Path(folder).glob(ext)))
            if videos:
                class_videos[label] = sorted(videos)

    # Balance target based on max video count per class
    max_videos = max(len(v) for v in class_videos.values()) if class_videos else 0
    target_frames = max_videos * frames_per_video

    # Weapon videos are short trimmed clips — cap FPV to avoid near-duplicate frames
    # from the same scene, but 18 gives more starting-point variety across 50 videos.
    MAX_FPV = {"weapon_detected": 18}

    for label in LABELS:
        label_idx = LABEL_TO_IDX[label]

        # --- A. Process Videos (with video-level split) ---
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

        # --- B. Process Static Images (with image-level split) ---
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

    # Summary
    print("\nDataset generation and split complete!")
    print("-" * 70)
    for label in LABELS:
        tr_c = sum(1 for s in train_samples if s["label"] == label)
        va_c = sum(1 for s in val_samples if s["label"] == label)
        print(f"✓ {label:<25} Train: {tr_c:>4} | Val: {va_c:>4}")

    print(f"\nTotal Train samples: {len(train_samples)}")
    print(f"Total Val samples:   {len(val_samples)}")

    return train_samples, val_samples


# ──────────────────────────────────────────────
#  Model builder
# ──────────────────────────────────────────────

def build_model(num_classes: int, freeze_backbone: bool = True):
    """EfficientNet-V2-S with a regularised classification head.

    EfficientNet-V2-S achieves 84.2% top-1 on ImageNet vs 76.1% for ResNet50,
    giving much richer pretrained features for fine-grained surveillance scenes.
    """
    model = models.efficientnet_v2_s(weights=models.EfficientNet_V2_S_Weights.IMAGENET1K_V1)

    if freeze_backbone:
        for param in model.parameters():
            param.requires_grad = False

    in_features = model.classifier[1].in_features  # 1280 for EfficientNet-V2-S
    model.classifier = nn.Sequential(
        nn.Dropout(p=0.4),
        nn.Linear(in_features, 512),
        nn.BatchNorm1d(512),
        nn.GELU(),
        nn.Dropout(p=0.3),
        nn.Linear(512, num_classes),
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


# ──────────────────────────────────────────────
#  Train
# ──────────────────────────────────────────────

def train(
    source_path="simulation/datasets/video",
    images_path="simulation/datasets/image",
    frames_path="ai_models/visual/classifier_frames",
    save_path="ai_models/visual/saved_model",
    total_epochs=80,
    unfreeze_epoch=15,
    batch_size=32,
    lr_head=1e-3,
    lr_backbone=8e-5,
    lr_head_ft=4e-5,
    weight_decay=0.01,
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

    # ── Extract & split data ───────────────────────────────────────
    train_samples, val_samples = extract_and_split_dataset(
        source_path, images_path, frames_path,
        frames_per_video=10, max_images_per_class=800
    )

    if not train_samples:
        print("\nNo training data found — add videos to simulation/datasets/video/")
        print("or images to simulation/datasets/image/<label>/")
        return

    # ── Balanced sampler ───────────────────────────────────────────
    train_labels = [s["label_idx"] for s in train_samples]
    train_counts = np.bincount(train_labels, minlength=NUM_CLASSES)

    class_weights = [1.0 / max(train_counts[i], 1) for i in range(NUM_CLASSES)]
    sample_weights = [class_weights[s["label_idx"]] for s in train_samples]
    sampler = WeightedRandomSampler(
        weights=sample_weights,
        num_samples=len(train_samples),
        replacement=True,
    )

    # ── Data loaders ───────────────────────────────────────────────
    train_loader = DataLoader(
        FrameDataset(train_samples, transform=train_transform),
        batch_size=batch_size,
        sampler=sampler,
        num_workers=0,
    )
    val_loader = DataLoader(
        FrameDataset(val_samples, transform=val_transform),
        batch_size=batch_size,
        shuffle=False,
        num_workers=0,
    )

    # ── Model ──────────────────────────────────────────────────────
    model = build_model(NUM_CLASSES, freeze_backbone=True).to(device)

    # ── Class-weighted loss ─────────────────────────────────────────
    # car_crash has ~454 samples vs 2000-3000 for other classes.
    # WeightedRandomSampler balances how often samples appear, but
    # class weights in the loss make the gradient STRONGER for rare classes.
    median_count = np.median(train_counts[train_counts > 0])
    loss_weights = torch.tensor([
        np.sqrt(median_count / max(train_counts[i], 1))
        for i in range(NUM_CLASSES)
    ], dtype=torch.float32).to(device)
    print(f"\n📊 Class weights for loss:")
    for i, label in enumerate(LABELS):
        print(f"   {label:<25} count={train_counts[i]:>5}  weight={loss_weights[i]:.2f}")

    criterion = FocalLoss(
        alpha=loss_weights,
        gamma=1.5,
        label_smoothing=0.0,
    )

    # Phase 1: only train the classifier head
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
    patience_limit = 12

    print(f"\n🚀 Starting training for {total_epochs} epochs...")
    print(f"   Phase 1 (epochs 1–{unfreeze_epoch}): Train classifier head only")
    print(f"   Phase 2 (epochs {unfreeze_epoch+1}+): Fine-tune layer3+layer4+head (MixUp α={mixup_alpha})")
    print(f"   Regularisation: weight_decay={weight_decay}, label_smoothing=0.05, dropout=0.35")
    print("=" * 60)

    for epoch in range(total_epochs):
        # ── Phase transitions ──────────────────────────────────────
        mid_phase2_epoch = unfreeze_epoch + (total_epochs - unfreeze_epoch) // 2

        if epoch == unfreeze_epoch:
            print(f"\n🔓 Unfreezing features.4-6 at epoch {epoch + 1}...")
            unfreeze_backbone(model, include_3=False)

            # 3-tier differential LR: deeper layers adapt slower.
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

            remaining_epochs = total_epochs - unfreeze_epoch
            scheduler = optim.lr_scheduler.CosineAnnealingLR(
                optimizer, T_max=remaining_epochs, eta_min=1e-6
            )
            patience_counter = 0

        elif epoch == mid_phase2_epoch:
            print(f"\n🔓 Unfreezing features.3 at epoch {epoch + 1} (mid-Phase 2)...")
            unfreeze_backbone(model, include_3=True)

            # Add features.3 params at a very low LR — they're far from the head.
            f3_params = [
                p for n, p in model.named_parameters()
                if "features.3" in n and p.requires_grad
            ]
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
                {"params": f3_params,   "lr": lr_backbone * 0.05},
                {"params": deep_params, "lr": lr_backbone * 0.1},
                {"params": mid_params,  "lr": lr_backbone * 0.5},
                {"params": head_params, "lr": lr_head_ft * 0.5},
            ], weight_decay=weight_decay)

            remaining_epochs = total_epochs - mid_phase2_epoch
            scheduler = optim.lr_scheduler.CosineAnnealingLR(
                optimizer, T_max=remaining_epochs, eta_min=1e-6
            )

        # ── Train ──────────────────────────────────────────────────
        model.train()
        train_loss = 0.0
        train_correct = 0
        train_total = 0

        for images, labels in train_loader:
            images = images.to(device)
            labels = labels.to(device)

            # MixUp/CutMix only in Phase 2 — the frozen-backbone head needs
            # clean class signals to learn decision boundaries first.
            if epoch >= unfreeze_epoch:
                if np.random.rand() < 0.5:
                    mixed_images, y_a, y_b, lam = mixup_data(images, labels, alpha=mixup_alpha)
                else:
                    mixed_images, y_a, y_b, lam = cutmix_data(images, labels, alpha=1.0)
            else:
                mixed_images, y_a, y_b, lam = images, labels, labels, 1.0

            optimizer.zero_grad()
            outputs = model(mixed_images)
            loss = mixup_criterion(criterion, outputs, y_a, y_b, lam)
            loss.backward()
            torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)
            optimizer.step()

            train_loss += loss.item()
            # Approximate accuracy using the dominant label
            _, predicted = outputs.max(1)
            train_total += labels.size(0)
            train_correct += (
                lam * predicted.eq(y_a).sum().item()
                + (1.0 - lam) * predicted.eq(y_b).sum().item()
            )

        train_acc = 100.0 * train_correct / train_total

        # ── Validate (no MixUp) ────────────────────────────────────
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
                _, predicted = outputs.max(1)
                val_total += labels.size(0)
                val_correct += predicted.eq(labels).sum().item()
                val_preds.extend(predicted.cpu().numpy())
                val_targets.extend(labels.cpu().numpy())

        val_acc = 100.0 * val_correct / val_total
        avg_val_loss = val_loss / len(val_loader)

        # Per-class breakdown — printed every 5 epochs and at phase boundary
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
            patience_counter += 1
            if patience_counter >= patience_limit:
                print(f"\n⏹ Early stopping at epoch {epoch + 1} (no improvement for {patience_limit} epochs)")
                break

    print("=" * 60)
    print(f"Training complete!")
    print(f"Best validation accuracy: {best_val_acc:.1f}%")
    print(f"Model saved to: {save_path}/best_classifier.pth")

    return best_val_acc


# ──────────────────────────────────────────────
#  Evaluate
# ──────────────────────────────────────────────

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

        # Test on first frame of first video
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
            probs = torch.softmax(output, dim=1)
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
