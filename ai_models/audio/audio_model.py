import torch
import torch.nn as nn
import librosa
import numpy as np
import json
import os

MIN_CONFIDENCE = 0.25

LABELS = [
    "normal",
    "gunshot",
    "impact",
    "distress_sounds",
    "forced_entry",
    "fight_sounds",
    "siren",
]
NUM_CLASSES = len(LABELS)
LABEL_TO_IDX = {label: idx for idx, label in enumerate(LABELS)}
IDX_TO_LABEL = {idx: label for idx, label in enumerate(LABELS)}

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

class AudioAnomalyDetector:
    MODEL_PATH = "ai_models/audio/saved_model/best_model.pth"
    LABELS_PATH = "ai_models/audio/saved_model/labels.json"

    def __init__(self):
        self.device = torch.device(
            "mps" if torch.backends.mps.is_available()
            else "cuda" if torch.cuda.is_available()
            else "cpu"
        )
        self.model = None
        self.idx_to_label = {idx: label for idx, label in enumerate(LABELS)}
        self._load_model()

    def _load_model(self):
        if not os.path.exists(self.MODEL_PATH):
            print(
                f"[AudioAnomalyDetector] No trained model found at {self.MODEL_PATH}. "
                "Run train_audio_model.py first."
            )
            return

        if os.path.exists(self.LABELS_PATH):
            with open(self.LABELS_PATH) as f:
                raw = json.load(f)
                self.idx_to_label = {int(k): v for k, v in raw.items()}

        checkpoint = torch.load(self.MODEL_PATH, map_location=self.device)
        num_classes = checkpoint["classifier.7.weight"].shape[0]
        self.model = AudioCNN(num_classes=num_classes).to(self.device)
        self.model.load_state_dict(checkpoint)
        self.model.eval()
        print(f"[AudioAnomalyDetector] Model loaded from {self.MODEL_PATH}")

    def _extract_features(self, audio: np.ndarray, sr: int) -> np.ndarray:
        target_length = sr * 3
        if len(audio) < target_length:
            audio = np.pad(audio, (0, target_length - len(audio)))
        else:
            audio = audio[:target_length]

        mel = librosa.feature.melspectrogram(
            y=audio, sr=sr, n_mels=128, fmax=8000
        )
        mel_db = librosa.power_to_db(mel, ref=np.max)
        mel_db = (mel_db - mel_db.min()) / (mel_db.max() - mel_db.min() + 1e-8)
        return mel_db.astype(np.float32)

    def predict(self, audio_chunk: np.ndarray, sr: int) -> dict:
        if self.model is None:
            return {"label": "normal", "confidence": 0.0, "error": "Model not loaded"}

        if np.max(np.abs(audio_chunk)) < 0.002:
            return {"label": "normal", "confidence": 0.99, "silent": True}

        features = self._extract_features(audio_chunk, sr)
        tensor = torch.tensor(features).unsqueeze(0).unsqueeze(0).to(self.device)

        with torch.no_grad():
            output = self.model(tensor)
            probs = torch.softmax(output, dim=1)

        top2_probs, top2_idx = probs.topk(2, dim=1)
        top1_conf = float(top2_probs[0][0])
        top1_label = self.idx_to_label.get(int(top2_idx[0][0]), "normal")
        top2_conf = float(top2_probs[0][1])
        top2_label = self.idx_to_label.get(int(top2_idx[0][1]), "normal")

        if top1_label == "normal":
            if top2_label != "normal" and top2_conf > 0.25:
                return {
                    "label": top2_label,
                    "confidence": round(top2_conf * 0.9, 3),
                }
            return {"label": "normal", "confidence": round(top1_conf, 3)}

        if top1_conf < MIN_CONFIDENCE:
            return {"label": "normal", "confidence": round(1.0 - top1_conf, 3)}

        return {
            "label": top1_label,
            "confidence": round(top1_conf, 3),
        }

    def predict_from_file(self, file_path: str) -> dict:
        try:
            audio, sr = librosa.load(file_path, sr=22050)
            return self.predict(audio, sr)
        except Exception as e:
            return {"label": "normal", "confidence": 0.0, "error": str(e)}

    def get_severity(self, label: str) -> str:
        high = [
            "gunshot", "impact", "distress_sounds",
            "fight_sounds", "forced_entry",
        ]
        medium = []
        low = ["siren"]

        if label in high:
            return "high"
        elif label in medium:
            return "medium"
        elif label in low:
            return "low"
        return "low"