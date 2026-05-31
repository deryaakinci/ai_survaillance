"""
train_visual_classifier.py
==========================
Train a ResNet34 image classifier for surveillance scene classification.

This replaces the broken YOLO-as-classifier approach.  YOLO is an object
*detection* model that needs real bounding-box annotations, but our data
only has whole-frame class labels.  A proper image classifier (ResNet34
with ImageNet pre-training) is the correct architecture for this task.

Training strategy:
  Phase 1 (epochs 1–10):  Freeze backbone, train only the new classifier head.
  Phase 2 (epochs 11+):   Unfreeze backbone, fine-tune end-to-end at a
                          lower learning rate.

Usage (from project root):
    python -m ai_models.visual.train_visual_classifier
"""

import os
import shutil
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
    transforms.RandomResizedCrop(224, scale=(0.8, 1.0)),
    transforms.RandomHorizontalFlip(),
    transforms.RandomRotation(15),
    transforms.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.1, hue=0.05),
    transforms.RandomGrayscale(p=0.05),
    transforms.ToTensor(),
    transforms.Normalize(IMAGENET_MEAN, IMAGENET_STD),
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

def extract_and_split_dataset(
    source_path="simulation/datasets/video",
    images_path="simulation/datasets/image",
    output_path="ai_models/visual/classifier_frames",
    frames_per_video=8,
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
    
    # Clean stale frames
    if os.path.exists(output_path):
        print("Cleaning stale classifier_frames directory...")
        shutil.rmtree(output_path)
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
                class_videos[label] = sorted(videos) # sorting for determinism
                
    # Balance target based on max video count per class
    max_videos = max(len(v) for v in class_videos.values()) if class_videos else 0
    target_frames = max_videos * frames_per_video
    
    for label in LABELS:
        label_idx = LABEL_TO_IDX[label]
        
        # --- A. Process Videos (with video-level split) ---
        if label in class_videos:
            videos = class_videos[label]
            np.random.shuffle(videos)
            
            # Split videos
            split_idx = int(len(videos) * (1.0 - test_size))
            train_videos = videos[:split_idx]
            val_videos = videos[split_idx:]
            
            # Extract frames for train videos
            if train_videos:
                fpv_train = max(1, int(np.ceil(target_frames / len(videos))))
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
                    
            # Extract frames for val videos
            if val_videos:
                fpv_val = max(1, int(np.ceil(target_frames / len(videos))))
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
                # Cap to prevent one class from dominating
                if len(images) > max_images_per_class:
                    np.random.shuffle(images)
                    images = images[:max_images_per_class]
                else:
                    np.random.shuffle(images)
                    
                split_idx = int(len(images) * (1.0 - test_size))
                train_images = images[:split_idx]
                val_images = images[split_idx:]
                
                # Add unique static images exactly once
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

    # Summary printing
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
    """ResNet34 with a new classification head."""
    model = models.resnet34(weights=models.ResNet34_Weights.IMAGENET1K_V1)

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
    """Unfreeze layer3, layer4, and the head for deeper fine-tuning while keeping low-level layers frozen."""
    for name, param in model.named_parameters():
        if "layer3" in name or "layer4" in name or "fc" in name:
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
    total_epochs=60,
    unfreeze_epoch=15,
    batch_size=32,
    lr_head=0.001,
    lr_finetune=0.0001,
):
    print("\n" + "=" * 60)
    print("   RESNET34 CLASSIFIER — SURVEILLANCE SCENE CLASSIFICATION")
    print("=" * 60)

    device = torch.device(
        "mps" if torch.backends.mps.is_available()
        else "cuda" if torch.cuda.is_available()
        else "cpu"
    )
    print(f"\nUsing device: {device}")

    # Strict split first
    train_samples, val_samples = extract_and_split_dataset(
        source_path, images_path, frames_path, frames_per_video=8, max_images_per_class=800
    )

    if not train_samples:
        print("\nNo training data found — add videos to simulation/datasets/video/")
        print("or images to simulation/datasets/image/<label>/")
        return

    # Train counts
    train_labels = [s["label_idx"] for s in train_samples]
    train_counts = np.bincount(train_labels, minlength=NUM_CLASSES)

    # ── Balanced sampler ───────────────────────────────────────────
    # Use exact inverse-frequency (1.0 / train_counts) to balance batches perfectly!
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

    # Label smoothing helps prevent overconfident wrong predictions.
    # 0.15 is more aggressive than default 0.1 — trades a small amount
    # of peak accuracy for significantly fewer high-confidence FPs.
    criterion = nn.CrossEntropyLoss(
        label_smoothing=0.15,
    )

    # Phase 1: only train the classifier head
    optimizer = optim.AdamW(
        filter(lambda p: p.requires_grad, model.parameters()),
        lr=lr_head,
        weight_decay=1e-4,
    )
    scheduler = optim.lr_scheduler.CosineAnnealingLR(
        optimizer, T_max=unfreeze_epoch, eta_min=1e-5
    )

    best_val_acc = 0.0
    patience_counter = 0
    patience_limit = 20

    print(f"\n🚀 Starting training for {total_epochs} epochs...")
    print(f"   Phase 1 (epochs 1–{unfreeze_epoch}): Train classifier head only")
    print(f"   Phase 2 (epochs {unfreeze_epoch+1}+): Fine-tune entire network")
    print("=" * 60)

    for epoch in range(total_epochs):
        # ── Phase 2: unfreeze backbone ─────────────────────────────
        if epoch == unfreeze_epoch:
            print(f"\n🔓 Unfreezing backbone at epoch {epoch + 1}...")
            unfreeze_backbone(model)
            optimizer = optim.AdamW(model.parameters(), lr=lr_finetune, weight_decay=1e-4)
            scheduler = optim.lr_scheduler.CosineAnnealingLR(
                optimizer, T_max=total_epochs - unfreeze_epoch, eta_min=1e-6
            )
            patience_counter = 0  # Reset early stopping counter for fine-tuning phase

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
            # Clip gradients to prevent instability during fine-tuning
            torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)
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
        if isinstance(scheduler, optim.lr_scheduler.ReduceLROnPlateau):
            scheduler.step(avg_val_loss)
        else:
            scheduler.step()

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
