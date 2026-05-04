"""
train_visual_classifier.py
==========================
Train a ResNet18 image classifier for surveillance scene classification.

This replaces the broken YOLO-as-classifier approach.  YOLO is an object
*detection* model that needs real bounding-box annotations, but our data
only has whole-frame class labels.  A proper image classifier (ResNet18
with ImageNet pre-training) is the correct architecture for this task.

Training strategy:
  Phase 1 (epochs 1–10):  Freeze backbone, train only the new classifier head.
  Phase 2 (epochs 11+):   Unfreeze backbone, fine-tune end-to-end at a
                          lower learning rate.

Usage (from project root):
    python -m ai_models.visual.train_visual_classifier
"""

import os
import cv2
import json
import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np
from pathlib import Path
from torch.utils.data import Dataset, DataLoader, WeightedRandomSampler
from torchvision import models, transforms
from sklearn.model_selection import train_test_split
from PIL import Image


LABELS = [
    "normal",
    "intruder_detected",
    "weapon_detected",
    "explosion",
    "vehicle_intrusion",
    "abuse",
    "fighting",
    "assault",
    "robbery",
    "person_down",
    "forced_entry",
]
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
        img = Image.open(item["path"]).convert("RGB")
        if self.transform:
            img = self.transform(img)
        label = torch.tensor(item["label_idx"], dtype=torch.long)
        return img, label


# ──────────────────────────────────────────────
#  Transforms
# ──────────────────────────────────────────────

# ImageNet normalisation stats
IMAGENET_MEAN = [0.485, 0.456, 0.406]
IMAGENET_STD  = [0.229, 0.224, 0.225]

train_transform = transforms.Compose([
    transforms.Resize((256, 256)),
    transforms.RandomResizedCrop(224, scale=(0.7, 1.0)),
    transforms.RandomHorizontalFlip(),
    transforms.RandomRotation(15),
    transforms.ColorJitter(brightness=0.3, contrast=0.3, saturation=0.2, hue=0.1),
    transforms.RandomGrayscale(p=0.1),
    transforms.RandomPerspective(distortion_scale=0.2, p=0.3),
    transforms.ToTensor(),
    transforms.Normalize(IMAGENET_MEAN, IMAGENET_STD),
    transforms.RandomErasing(p=0.2, scale=(0.02, 0.15)),
])

val_transform = transforms.Compose([
    transforms.Resize((256, 256)),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(IMAGENET_MEAN, IMAGENET_STD),
])


# ──────────────────────────────────────────────
#  Frame extraction
# ──────────────────────────────────────────────

def extract_frames(
    source_path="simulation/datasets/video",
    output_path="ai_models/visual/classifier_frames",
    frames_per_video=8,
):
    """Extract balanced frames from video dataset and save as JPEGs."""

    print("\n📸 Extracting frames from videos...")
    print("-" * 50)

    os.makedirs(output_path, exist_ok=True)

    # Count videos per class
    class_videos = {}
    for label in LABELS:
        folder = os.path.join(source_path, label)
        if os.path.exists(folder):
            videos = []
            for ext in ["*.mp4", "*.avi", "*.mov"]:
                videos.extend(list(Path(folder).glob(ext)))
            if videos:
                class_videos[label] = videos

    if not class_videos:
        print("No video files found!")
        return []

    # Balance: oversample minority classes to match the largest class
    max_videos = max(len(v) for v in class_videos.values())
    target_frames = max_videos * frames_per_video

    all_samples = []

    for label in LABELS:
        if label not in class_videos:
            print(f"⚠ Skipping {label} — no video files")
            continue

        video_files = class_videos[label]
        label_idx = LABEL_TO_IDX[label]
        label_dir = os.path.join(output_path, label)
        os.makedirs(label_dir, exist_ok=True)

        # How many frames per video to hit the target
        fpv = max(1, int(np.ceil(target_frames / len(video_files))))
        frame_count = 0

        for video_path in video_files:
            cap = cv2.VideoCapture(str(video_path))
            total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))

            if total_frames <= 0:
                cap.release()
                continue

            num_to_extract = min(fpv, total_frames)
            frame_indices = np.linspace(0, total_frames - 1, num_to_extract, dtype=int)

            for idx in frame_indices:
                cap.set(cv2.CAP_PROP_POS_FRAMES, idx)
                ret, frame = cap.read()
                if not ret:
                    continue

                fname = f"{label}_{video_path.stem}_f{idx}.jpg"
                fpath = os.path.join(label_dir, fname)

                if not os.path.exists(fpath):
                    cv2.imwrite(fpath, frame)

                all_samples.append({
                    "path": fpath,
                    "label_idx": label_idx,
                    "label": label,
                })
                frame_count += 1

            cap.release()

        print(f"✓ {label:<25} {frame_count} frames (from {len(video_files)} videos)")

    print(f"\nTotal frames: {len(all_samples)}")
    return all_samples


# ──────────────────────────────────────────────
#  Model builder
# ──────────────────────────────────────────────

def build_model(num_classes: int, freeze_backbone: bool = True):
    """ResNet18 with a new classification head."""
    model = models.resnet18(weights=models.ResNet18_Weights.IMAGENET1K_V1)

    if freeze_backbone:
        for param in model.parameters():
            param.requires_grad = False

    # Replace final FC layer
    in_features = model.fc.in_features
    model.fc = nn.Sequential(
        nn.Dropout(0.4),
        nn.Linear(in_features, 256),
        nn.ReLU(),
        nn.Dropout(0.3),
        nn.Linear(256, num_classes),
    )

    return model


def unfreeze_backbone(model):
    """Unfreeze all layers for fine-tuning."""
    for param in model.parameters():
        param.requires_grad = True


# ──────────────────────────────────────────────
#  Train
# ──────────────────────────────────────────────

def train(
    source_path="simulation/datasets/video",
    frames_path="ai_models/visual/classifier_frames",
    save_path="ai_models/visual/saved_model",
    total_epochs=60,
    unfreeze_epoch=10,
    batch_size=32,
    lr_head=0.001,
    lr_finetune=0.0001,
):
    print("\n" + "=" * 60)
    print("   RESNET18 CLASSIFIER — SURVEILLANCE SCENE CLASSIFICATION")
    print("=" * 60)

    device = torch.device(
        "mps" if torch.backends.mps.is_available()
        else "cuda" if torch.cuda.is_available()
        else "cpu"
    )
    print(f"\nUsing device: {device}")

    # ── Extract frames ─────────────────────────────────────────────
    all_samples = extract_frames(source_path, frames_path)
    if not all_samples:
        print("\nNo frames extracted — add videos to simulation/datasets/video/")
        return

    # ── Stratified train/val split ─────────────────────────────────
    labels = [s["label_idx"] for s in all_samples]
    counts = np.bincount(labels, minlength=NUM_CLASSES)
    can_stratify = int(counts[counts > 0].min()) >= 2

    if can_stratify:
        train_samples, val_samples = train_test_split(
            all_samples, test_size=0.2, random_state=42, stratify=labels,
        )
    else:
        train_samples, val_samples = train_test_split(
            all_samples, test_size=0.2, random_state=42,
        )

    print(f"\nTrain samples : {len(train_samples)}")
    print(f"Val samples   : {len(val_samples)}")

    # ── Class weights ──────────────────────────────────────────────
    train_labels = [s["label_idx"] for s in train_samples]
    train_counts = np.bincount(train_labels, minlength=NUM_CLASSES)

    print(f"\nClass distribution (train):")
    for i, label in enumerate(LABELS):
        print(f"  {label:<25} {train_counts[i]:>5} frames")

    # Sqrt-inverse-frequency weights
    class_weights = np.zeros(NUM_CLASSES, dtype=np.float32)
    for i in range(NUM_CLASSES):
        if train_counts[i] > 0:
            class_weights[i] = 1.0 / np.sqrt(train_counts[i])
    if class_weights.sum() > 0:
        class_weights = class_weights / class_weights.sum() * NUM_CLASSES
    class_weights_tensor = torch.tensor(class_weights).to(device)

    print(f"\nClass weights: {dict(zip(LABELS, [f'{w:.2f}' for w in class_weights]))}")

    # ── Balanced sampler ───────────────────────────────────────────
    sample_weights = [
        1.0 / np.sqrt(max(train_counts[s["label_idx"]], 1))
        for s in train_samples
    ]
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

    # Label smoothing helps prevent overconfident wrong predictions
    criterion = nn.CrossEntropyLoss(
        weight=class_weights_tensor,
        label_smoothing=0.1,
    )

    # Phase 1: only train the classifier head
    optimizer = optim.Adam(
        filter(lambda p: p.requires_grad, model.parameters()),
        lr=lr_head,
    )
    scheduler = optim.lr_scheduler.ReduceLROnPlateau(
        optimizer, mode="min", patience=5, factor=0.5,
    )

    best_val_acc = 0.0
    patience_counter = 0
    patience_limit = 15

    print(f"\n🚀 Starting training for {total_epochs} epochs...")
    print(f"   Phase 1 (epochs 1–{unfreeze_epoch}): Train classifier head only")
    print(f"   Phase 2 (epochs {unfreeze_epoch+1}+): Fine-tune entire network")
    print("=" * 60)

    for epoch in range(total_epochs):
        # ── Phase 2: unfreeze backbone ─────────────────────────────
        if epoch == unfreeze_epoch:
            print(f"\n🔓 Unfreezing backbone at epoch {epoch + 1}...")
            unfreeze_backbone(model)
            optimizer = optim.Adam(model.parameters(), lr=lr_finetune)
            scheduler = optim.lr_scheduler.ReduceLROnPlateau(
                optimizer, mode="min", patience=7, factor=0.5,
            )

        # ── Train ──────────────────────────────────────────────────
        model.train()
        train_loss = 0.0
        train_correct = 0
        train_total = 0

        for images, labels in train_loader:
            images = images.to(device)
            labels = labels.to(device)

            optimizer.zero_grad()
            outputs = model(images)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()

            train_loss += loss.item()
            _, predicted = outputs.max(1)
            train_total += labels.size(0)
            train_correct += predicted.eq(labels).sum().item()

        train_acc = 100.0 * train_correct / train_total

        # ── Validate ───────────────────────────────────────────────
        model.eval()
        val_loss = 0.0
        val_correct = 0
        val_total = 0

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

        val_acc = 100.0 * val_correct / val_total
        avg_val_loss = val_loss / len(val_loader)
        scheduler.step(avg_val_loss)

        current_lr = optimizer.param_groups[0]["lr"]
        phase = "HEAD" if epoch < unfreeze_epoch else "FULL"

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

        # Convert BGR → RGB → PIL
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
