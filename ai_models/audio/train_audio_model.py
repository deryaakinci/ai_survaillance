import os
import torch
import torch.nn as nn
import torch.optim as optim
import librosa
import numpy as np
from torch.utils.data import Dataset, DataLoader
from sklearn.model_selection import train_test_split
from pathlib import Path
import json


LABELS = [
    "normal",
    "gunshot",
    "explosion",
    "scream",
    "glass_break",
    "break_in",
    "door_forced",
    "crying_distress",
    "fight_sounds",
    "alarm_triggered",
    "siren",
    "car_crash",
    "threatening_voice",
]
LABEL_TO_IDX = {label: idx for idx, label in enumerate(LABELS)}
IDX_TO_LABEL = {idx: label for label, idx in LABEL_TO_IDX.items()}
NUM_CLASSES = len(LABELS)


def extract_features(audio: np.ndarray, sr: int) -> np.ndarray:
    target_length = sr * 3
    if len(audio) < target_length:
        audio = np.pad(audio, (0, target_length - len(audio)))
    else:
        audio = audio[:target_length]

    mel = librosa.feature.melspectrogram(
        y=audio,
        sr=sr,
        n_mels=128,
        fmax=8000,
    )
    mel_db = librosa.power_to_db(mel, ref=np.max)
    mel_db = (mel_db - mel_db.min()) / (mel_db.max() - mel_db.min() + 1e-8)
    return mel_db.astype(np.float32)


class AudioDataset(Dataset):
    def __init__(self, samples):
        self.samples = samples

    def __len__(self):
        return len(self.samples)

    def __getitem__(self, idx):
        item = self.samples[idx]
        features = torch.tensor(item["features"]).unsqueeze(0)
        label = torch.tensor(item["label_idx"], dtype=torch.long)
        return features, label


def load_dataset(base_path="simulation/datasets/audio"):
    all_samples = []
    print("\nLoading audio dataset...")
    print("-" * 40)

    for label in LABELS:
        folder = os.path.join(base_path, label)
        if not os.path.exists(folder):
            print(f"⚠ Skipping {label} — folder not found")
            continue

        files = list(Path(folder).glob("*.wav"))
        if not files:
            print(f"⚠ Skipping {label} — no .wav files")
            continue

        label_idx = LABEL_TO_IDX[label]
        count = 0

        for file in files:
            try:
                audio, sr = librosa.load(str(file), sr=22050)
                features = extract_features(audio, sr)
                all_samples.append({
                    "features": features,
                    "label": label,
                    "label_idx": label_idx,
                    "file": str(file),
                })
                count += 1
            except Exception as e:
                print(f"  Could not load {file.name}: {e}")

        print(f"✓ {label:<25} {count} files loaded")

    print("-" * 40)
    print(f"Total samples: {len(all_samples)}")
    return all_samples


class AudioCNN(nn.Module):
    def __init__(self, num_classes: int):
        super(AudioCNN, self).__init__()

        self.conv_block1 = nn.Sequential(
            nn.Conv2d(1, 32, kernel_size=3, padding=1),
            nn.BatchNorm2d(32),
            nn.ReLU(),
            nn.MaxPool2d(2),
            nn.Dropout2d(0.25),
        )
        self.conv_block2 = nn.Sequential(
            nn.Conv2d(32, 64, kernel_size=3, padding=1),
            nn.BatchNorm2d(64),
            nn.ReLU(),
            nn.MaxPool2d(2),
            nn.Dropout2d(0.25),
        )
        self.conv_block3 = nn.Sequential(
            nn.Conv2d(64, 128, kernel_size=3, padding=1),
            nn.BatchNorm2d(128),
            nn.ReLU(),
            nn.MaxPool2d(2),
            nn.Dropout2d(0.25),
        )
        self.adaptive_pool = nn.AdaptiveAvgPool2d((4, 4))
        self.classifier = nn.Sequential(
            nn.Flatten(),
            nn.Linear(128 * 4 * 4, 256),
            nn.ReLU(),
            nn.Dropout(0.5),
            nn.Linear(256, 128),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(128, num_classes),
        )

    def forward(self, x):
        x = self.conv_block1(x)
        x = self.conv_block2(x)
        x = self.conv_block3(x)
        x = self.adaptive_pool(x)
        x = self.classifier(x)
        return x


def train(
    base_path="simulation/datasets/audio",
    epochs=30,
    batch_size=16,
    learning_rate=0.001,
    save_path="ai_models/audio/saved_model",
):
    device = torch.device(
        "mps" if torch.backends.mps.is_available()
        else "cuda" if torch.cuda.is_available()
        else "cpu"
    )
    print(f"\nUsing device: {device}")

    all_samples = load_dataset(base_path)
    if len(all_samples) == 0:
        print("\nNo samples found!")
        print("Add .wav files to your dataset folders first.")
        return

    train_samples, val_samples = train_test_split(
        all_samples,
        test_size=0.2,
        random_state=42,
        stratify=[s["label_idx"] for s in all_samples],
    )

    print(f"\nTrain samples : {len(train_samples)}")
    print(f"Val samples   : {len(val_samples)}")

    train_loader = DataLoader(
        AudioDataset(train_samples),
        batch_size=batch_size,
        shuffle=True,
    )
    val_loader = DataLoader(
        AudioDataset(val_samples),
        batch_size=batch_size,
        shuffle=False,
    )

    model = AudioCNN(num_classes=NUM_CLASSES).to(device)
    criterion = nn.CrossEntropyLoss()
    optimizer = optim.Adam(model.parameters(), lr=learning_rate)
    scheduler = optim.lr_scheduler.ReduceLROnPlateau(
        optimizer, patience=5, factor=0.5,
    )

    best_val_acc = 0.0
    print(f"\nStarting training for {epochs} epochs...")
    print("=" * 55)

    for epoch in range(epochs):
        model.train()
        train_loss = 0.0
        train_correct = 0
        train_total = 0

        for features, labels in train_loader:
            features = features.to(device)
            labels = labels.to(device)
            optimizer.zero_grad()
            outputs = model(features)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()
            train_loss += loss.item()
            _, predicted = outputs.max(1)
            train_total += labels.size(0)
            train_correct += predicted.eq(labels).sum().item()

        train_acc = 100.0 * train_correct / train_total

        model.eval()
        val_loss = 0.0
        val_correct = 0
        val_total = 0

        with torch.no_grad():
            for features, labels in val_loader:
                features = features.to(device)
                labels = labels.to(device)
                outputs = model(features)
                loss = criterion(outputs, labels)
                val_loss += loss.item()
                _, predicted = outputs.max(1)
                val_total += labels.size(0)
                val_correct += predicted.eq(labels).sum().item()

        val_acc = 100.0 * val_correct / val_total
        scheduler.step(val_loss)

        print(
            f"Epoch {epoch+1:>3}/{epochs} | "
            f"Train loss: {train_loss/len(train_loader):.4f} | "
            f"Train acc: {train_acc:.1f}% | "
            f"Val loss: {val_loss/len(val_loader):.4f} | "
            f"Val acc: {val_acc:.1f}%"
        )

        if val_acc > best_val_acc:
            best_val_acc = val_acc
            os.makedirs(save_path, exist_ok=True)
            torch.save(
                model.state_dict(),
                f"{save_path}/best_model.pth",
            )
            with open(f"{save_path}/labels.json", "w") as f:
                json.dump(IDX_TO_LABEL, f)
            print(f"  ✓ Best model saved — val acc: {val_acc:.1f}%")

    print("=" * 55)
    print(f"Training complete!")
    print(f"Best validation accuracy: {best_val_acc:.1f}%")
    print(f"Model saved to: {save_path}/best_model.pth")


def evaluate(save_path="ai_models/audio/saved_model"):
    device = torch.device(
        "mps" if torch.backends.mps.is_available() else "cpu"
    )

    model_path = f"{save_path}/best_model.pth"
    if not os.path.exists(model_path):
        print("No trained model found. Run training first.")
        return

    model = AudioCNN(num_classes=NUM_CLASSES).to(device)
    model.load_state_dict(
        torch.load(model_path, map_location=device)
    )
    model.eval()

    print("\nEvaluating model on sample files...")
    print("-" * 40)

    for label in LABELS:
        folder = f"simulation/datasets/audio/{label}"
        files = list(Path(folder).glob("*.wav"))
        if not files:
            continue

        audio, sr = librosa.load(str(files[0]), sr=22050)
        features = extract_features(audio, sr)
        tensor = torch.tensor(features).unsqueeze(0).unsqueeze(0).to(device)

        with torch.no_grad():
            output = model(tensor)
            probs = torch.softmax(output, dim=1)
            confidence, predicted_idx = probs.max(1)
            predicted_label = IDX_TO_LABEL[predicted_idx.item()]

        symbol = "✓" if predicted_label == label else "✗"
        print(
            f"{symbol} True: {label:<20} "
            f"Predicted: {predicted_label:<20} "
            f"Confidence: {confidence.item():.2f}"
        )


if __name__ == "__main__":
    train()
    evaluate()