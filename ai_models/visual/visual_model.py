import cv2
import numpy as np
import torch
import torch.nn as nn
from torchvision import models, transforms
from PIL import Image
import os


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

CLASSIFIER_MODEL_PATH = "ai_models/visual/saved_model/best_classifier.pth"
FALLBACK_MODEL_PATH = "yolov8n.pt"

# Minimum confidence to report an anomaly — below this we say "normal"
MIN_CONFIDENCE = 0.30


# ── ImageNet normalisation (must match training) ──────────────────────
IMAGENET_MEAN = [0.485, 0.456, 0.406]
IMAGENET_STD  = [0.229, 0.224, 0.225]

_inference_transform = transforms.Compose([
    transforms.Resize((256, 256)),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(IMAGENET_MEAN, IMAGENET_STD),
])


def _build_classifier(num_classes: int):
    """Rebuild the same architecture used during training."""
    model = models.resnet18(weights=None)
    in_features = model.fc.in_features
    model.fc = nn.Sequential(
        nn.Dropout(0.4),
        nn.Linear(in_features, 256),
        nn.ReLU(),
        nn.Dropout(0.3),
        nn.Linear(256, num_classes),
    )
    return model


class VisualAnomalyDetector:
    def __init__(self):
        self.is_classifier = False
        self.is_finetuned = False
        self.device = torch.device(
            "mps" if torch.backends.mps.is_available()
            else "cuda" if torch.cuda.is_available()
            else "cpu"
        )

        if os.path.exists(CLASSIFIER_MODEL_PATH):
            self.model = _build_classifier(len(LABELS)).to(self.device)
            self.model.load_state_dict(
                torch.load(CLASSIFIER_MODEL_PATH, map_location=self.device)
            )
            self.model.eval()
            self.is_classifier = True
            print(
                f"[VisualAnomalyDetector] ResNet18 classifier loaded from "
                f"{CLASSIFIER_MODEL_PATH}"
            )
        else:
            # Fallback: try YOLO (fine-tuned or base)
            try:
                from ultralytics import YOLO

                FINETUNED_MODEL_PATH = (
                    "ai_models/visual/saved_model/surveillance_model/weights/best.pt"
                )
                if os.path.exists(FINETUNED_MODEL_PATH):
                    self.model = YOLO(FINETUNED_MODEL_PATH)
                    self.is_finetuned = True
                    print(
                        f"[VisualAnomalyDetector] YOLO fine-tuned model loaded "
                        f"from {FINETUNED_MODEL_PATH}"
                    )
                else:
                    self.model = YOLO(FALLBACK_MODEL_PATH)
                    print(
                        "[VisualAnomalyDetector] No classifier or fine-tuned model "
                        "found — using base yolov8n.pt. Run train_visual_classifier.py first."
                    )
            except ImportError:
                self.model = None
                print(
                    "[VisualAnomalyDetector] No model available. "
                    "Run train_visual_classifier.py first."
                )

    # High-severity labels that should take priority even at lower confidence
    HIGH_PRIORITY_LABELS = {
        "weapon_detected", "explosion", "person_down",
        "forced_entry", "assault", "robbery", "abuse",
    }

    def predict(self, frame) -> dict:
        if self.is_classifier:
            return self._predict_classifier(frame)
        elif self.is_finetuned:
            from ultralytics import YOLO
            results = self.model(frame, verbose=False, conf=0.10, imgsz=1280)
            return self._predict_finetuned(results)
        elif self.model is not None:
            results = self.model(frame, verbose=False, conf=0.10, imgsz=1280)
            return self._predict_base(frame, results)
        else:
            return {"label": "normal", "confidence": 0.0}

    def _predict_classifier(self, frame) -> dict:
        """
        ResNet18 classifier: takes a full frame, returns scene-level label.
        Uses softmax + confidence thresholding.
        """
        # Convert BGR (OpenCV) → RGB → PIL → tensor
        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        img = Image.fromarray(frame_rgb)
        tensor = _inference_transform(img).unsqueeze(0).to(self.device)

        with torch.no_grad():
            output = self.model(tensor)
            probs = torch.softmax(output, dim=1)

        # Get top-2 predictions for smarter decision-making
        top2_probs, top2_idx = probs.topk(2, dim=1)
        top1_conf = float(top2_probs[0][0])
        top1_label = LABELS[int(top2_idx[0][0])]
        top2_conf = float(top2_probs[0][1])
        top2_label = LABELS[int(top2_idx[0][1])]

        # If top prediction is "normal", check if the 2nd prediction
        # is an anomaly with decent confidence — might be borderline
        if top1_label == "normal":
            if top2_label != "normal" and top2_conf > 0.20:
                # Borderline case: report the anomaly with reduced confidence
                return {
                    "label": top2_label,
                    "confidence": round(top2_conf * 0.9, 3),
                }
            return {"label": "normal", "confidence": round(top1_conf, 3)}

        # If anomaly confidence is below threshold, report normal
        if top1_conf < MIN_CONFIDENCE:
            return {"label": "normal", "confidence": round(1.0 - top1_conf, 3)}

        return {
            "label": top1_label,
            "confidence": round(top1_conf, 3),
        }

    def _predict_finetuned(self, results) -> dict:
        """
        Fine-tuned YOLO model outputs our custom surveillance labels directly.
        Uses severity-based priority: high-severity labels (e.g. weapon_detected)
        take precedence even if they have lower confidence than generic detections.
        """
        high_prio_label = None
        high_prio_score = 0.0
        other_label = None
        other_score = 0.0

        for result in results:
            for box in result.boxes:
                confidence = float(box.conf[0])
                cls_id = int(box.cls[0])
                label = (
                    LABELS[cls_id]
                    if cls_id < len(LABELS)
                    else "normal"
                )
                if label == "normal":
                    continue

                if label in self.HIGH_PRIORITY_LABELS:
                    if confidence > high_prio_score:
                        high_prio_label = label
                        high_prio_score = confidence
                else:
                    if confidence > other_score:
                        other_label = label
                        other_score = confidence

        # Prefer high-priority detections (even at lower confidence)
        if high_prio_label is not None:
            return {
                "label": high_prio_label,
                "confidence": round(high_prio_score, 3),
            }
        if other_label is not None:
            return {
                "label": other_label,
                "confidence": round(other_score, 3),
            }

        return {"label": "normal", "confidence": 0.95}

    def _predict_base(self, frame, results) -> dict:
        """
        Fallback: base yolov8n outputs COCO classes.
        Map them heuristically to our surveillance labels.
        """
        weapon_objects = ["knife", "gun", "scissors", "baseball bat"]
        vehicle_objects = ["car", "motorcycle", "truck", "bus"]

        detections = []
        for result in results:
            for box in result.boxes:
                cls_id = int(box.cls[0])
                label = self.model.names[cls_id]
                confidence = float(box.conf[0])
                if confidence > 0.4:
                    detections.append({
                        "label": label,
                        "confidence": round(confidence, 3),
                        "bbox": box.xyxy[0].tolist(),
                    })

        if not detections:
            return {"label": "normal", "confidence": 0.95}

        person_count = sum(1 for d in detections if d["label"] == "person")
        has_weapon = any(d["label"] in weapon_objects for d in detections)
        has_vehicle = any(d["label"] in vehicle_objects for d in detections)
        has_backpack = any(d["label"] == "backpack" for d in detections)
        is_dark = self._check_low_light(frame)

        if has_weapon:
            return {"label": "weapon_detected", "confidence": 0.98}
        if person_count >= 1 and self._check_person_down(detections):
            return {"label": "person_down", "confidence": 0.91}
        if person_count >= 4:
            return {"label": "assault", "confidence": round(min(0.70 + person_count * 0.05, 0.97), 3)}
        if person_count in [2, 3]:
            return {"label": "explosion", "confidence": round(min(0.65 + person_count * 0.07, 0.95), 3)}
        if person_count == 1 and is_dark:
            return {"label": "robbery", "confidence": 0.87}
        if person_count == 1:
            return {"label": "intruder_detected", "confidence": 0.88}
        if has_backpack and person_count == 0:
            return {"label": "suspicious_package", "confidence": 0.83}
        if has_vehicle and person_count == 0:
            return {"label": "vehicle_intrusion", "confidence": 0.82}

        return {"label": "normal", "confidence": 0.90}

    def _check_low_light(self, frame) -> bool:
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        return float(np.mean(gray)) < 60.0

    def _check_person_down(self, detections) -> bool:
        for d in detections:
            if d["label"] == "person":
                bbox = d["bbox"]
                width = bbox[2] - bbox[0]
                height = bbox[3] - bbox[1]
                if width > height * 1.5:
                    return True
        return False

    def predict_from_file(self, file_path: str) -> dict:
        try:
            cap = cv2.VideoCapture(file_path)
            ret, frame = cap.read()
            cap.release()
            if ret:
                return self.predict(frame)
            return {"label": "normal", "confidence": 0.0}
        except Exception as e:
            return {"label": "normal", "confidence": 0.0, "error": str(e)}

    def get_severity(self, label: str) -> str:
        high = [
            "weapon_detected", "person_down", "explosion",
            "robbery", "forced_entry", "assault", "abuse"
        ]
        medium = [
            "intruder_detected", "vehicle_intrusion",
            "fighting", "suspicious_package",
        ]
        low = []

        if label in high:
            return "high"
        elif label in medium:
            return "medium"
        elif label in low:
            return "low"
        return "low"