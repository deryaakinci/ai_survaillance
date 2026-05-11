import cv2
import numpy as np
import torch
import torch.nn as nn
from torchvision import models, transforms
from PIL import Image
import os


LABELS = [
    "normal",
    "weapon_detected",
    "explosion",
    "vehicle_intrusion",
    "violence",
    "robbery",
    "person_down",
    "intrusion_detected",
    "suspicious_package",
]

CLASSIFIER_MODEL_PATH = "ai_models/visual/saved_model/best_classifier.pth"
FINETUNED_YOLO_PATH   = "ai_models/visual/saved_model/surveillance_model/weights/best.pt"
FALLBACK_MODEL_PATH   = "yolov8n.pt"

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
    WEAPON_COCO_LABELS = {"knife", "scissors", "baseball bat"}

    HIGH_PRIORITY_LABELS = {
        "weapon_detected", "explosion", "person_down",
        "intrusion_detected", "violence", "robbery",
    }

    def __init__(self):
        self.resnet  = None   # ResNet18 scene classifier
        self.yolo    = None   # fine-tuned surveillance YOLO
        self.yolo_base = None # base yolov8n for COCO weapon scan
        self.device = torch.device(
            "mps" if torch.backends.mps.is_available()
            else "cuda" if torch.cuda.is_available()
            else "cpu"
        )

        # ── Load ResNet18 ──────────────────────────────────────────────
        if os.path.exists(CLASSIFIER_MODEL_PATH):
            self.resnet = _build_classifier(len(LABELS)).to(self.device)
            self.resnet.load_state_dict(
                torch.load(CLASSIFIER_MODEL_PATH, map_location=self.device)
            )
            self.resnet.eval()
            print(f"[VisualAnomalyDetector] ResNet18 loaded from {CLASSIFIER_MODEL_PATH}")
        else:
            print("[VisualAnomalyDetector] ResNet18 not found — run train_visual_classifier.py")

        # ── Load YOLO models ────────────────────────────────────────────
        # Always load base YOLO for COCO weapon detection (knife, scissors,
        # baseball bat).  Its pretrained weapon knowledge is stronger than
        # anything our small custom dataset can teach.
        try:
            from ultralytics import YOLO as _YOLO
            self.yolo_base = _YOLO(FALLBACK_MODEL_PATH)
            print("[VisualAnomalyDetector] Base YOLO loaded for COCO weapon detection")

            if os.path.exists(FINETUNED_YOLO_PATH):
                self.yolo = _YOLO(FINETUNED_YOLO_PATH)
                print(f"[VisualAnomalyDetector] Fine-tuned YOLO loaded from {FINETUNED_YOLO_PATH}")
        except ImportError:
            print("[VisualAnomalyDetector] ultralytics not installed — YOLO unavailable")

    # ── Public entry point ────────────────────────────────────────────

    def predict(self, frame) -> dict:
        # ── COCO weapon scan first — highest priority ──────────────
        weapon_hit = self._run_weapon_scan(frame)
        if weapon_hit is not None:
            return weapon_hit

        yolo_result   = self._run_yolo(frame)
        resnet_result = self._run_resnet(frame)

        if yolo_result is None and resnet_result is None:
            return {"label": "normal", "confidence": 0.0}
        if yolo_result is None:
            result = resnet_result
        elif resnet_result is None:
            result = yolo_result
        else:
            result = self._ensemble(yolo_result, resnet_result)

        # If undetermined (low confidence), treat as normal
        if result["label"] != "normal" and result["confidence"] < MIN_CONFIDENCE:
            return {"label": "normal", "confidence": round(1.0 - result["confidence"], 3)}

        return result

    # ── Per-model runners ─────────────────────────────────────────────

    def _run_weapon_scan(self, frame) -> dict | None:
        """Use base YOLO (COCO-pretrained) to detect weapons.
        This preserves YOLO's strong weapon knowledge even after fine-tuning."""
        if self.yolo_base is None:
            return None

        results = self.yolo_base(frame, verbose=False, conf=0.35)

        best_conf = 0.0
        for result in results:
            for box in result.boxes:
                cls_id = int(box.cls[0])
                label = self.yolo_base.names[cls_id]
                confidence = float(box.conf[0])
                if label in self.WEAPON_COCO_LABELS and confidence > best_conf:
                    best_conf = confidence

        if best_conf > 0.35:
            return {"label": "weapon_detected", "confidence": round(min(best_conf * 1.1, 0.99), 3)}

        return None

    def _run_yolo(self, frame) -> dict | None:
        """Run the fine-tuned YOLO for surveillance classes.
        Falls back to base YOLO heuristic mapping if no fine-tuned model."""
        if self.yolo is not None:
            results = self.yolo(frame, verbose=False, conf=0.10, imgsz=1280)
            return self._predict_finetuned(results)
        if self.yolo_base is not None:
            results = self.yolo_base(frame, verbose=False, conf=0.10, imgsz=1280)
            return self._predict_base(frame, results)
        return None

    def _run_resnet(self, frame) -> dict | None:
        if self.resnet is None:
            return None

        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        img = Image.fromarray(frame_rgb)
        tensor = _inference_transform(img).unsqueeze(0).to(self.device)

        with torch.no_grad():
            output = self.resnet(tensor)
            probs  = torch.softmax(output, dim=1)

        top2_probs, top2_idx = probs.topk(2, dim=1)
        top1_conf  = float(top2_probs[0][0])
        top1_label = LABELS[int(top2_idx[0][0])]
        top2_conf  = float(top2_probs[0][1])
        top2_label = LABELS[int(top2_idx[0][1])]

        if top1_label == "normal":
            if top2_label != "normal" and top2_conf > 0.25:
                return {"label": top2_label, "confidence": round(top2_conf * 0.9, 3)}
            return {"label": "normal", "confidence": round(top1_conf, 3)}

        if top1_conf < MIN_CONFIDENCE:
            return {"label": "normal", "confidence": round(1.0 - top1_conf, 3)}

        return {"label": top1_label, "confidence": round(top1_conf, 3)}

    # ── Ensemble consensus ────────────────────────────────────────────

    def _ensemble(self, yolo: dict, resnet: dict) -> dict:
        y_label = yolo["label"]
        y_conf  = yolo["confidence"]
        r_label = resnet["label"]
        r_conf  = resnet["confidence"]

        # YOLO has absolute priority on weapons — no consensus needed
        if y_label == "weapon_detected":
            return {"label": "weapon_detected", "confidence": round(min(y_conf * 1.1, 0.99), 3)}

        # Both agree → strong confidence boost
        if y_label == r_label:
            return {"label": y_label, "confidence": round(min(max(y_conf, r_conf) * 1.15, 0.99), 3)}

        # Both flag an anomaly but disagree on class → YOLO wins, small penalty
        if y_label != "normal" and r_label != "normal":
            return {"label": y_label, "confidence": round(max(y_conf, r_conf) * 0.85, 3)}

        # Only YOLO fires → trust it with a small penalty
        if y_label != "normal":
            return {"label": y_label, "confidence": round(y_conf * 0.85, 3)}

        # Only ResNet18 fires → trust it with a small penalty
        if r_label != "normal":
            return {"label": r_label, "confidence": round(r_conf * 0.85, 3)}

        return {"label": "normal", "confidence": round(max(y_conf, r_conf), 3)}

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
        Only map detections that COCO can reliably identify — weapons,
        vehicles, and suspicious packages.  Action-based classes like
        violence, robbery, explosion are left to the fine-tuned model
        and ResNet since COCO cannot detect actions.
        """
        weapon_objects = ["knife", "scissors", "baseball bat"]
        vehicle_objects = ["car", "motorcycle", "truck", "bus"]

        detections = []
        for result in results:
            for box in result.boxes:
                cls_id = int(box.cls[0])
                label = self.yolo_base.names[cls_id]
                confidence = float(box.conf[0])
                if confidence > 0.4:
                    detections.append({
                        "label": label,
                        "confidence": round(confidence, 3),
                        "bbox": box.xyxy[0].tolist(),
                    })

        if not detections:
            return {"label": "normal", "confidence": 0.95}

        has_weapon = any(d["label"] in weapon_objects for d in detections)
        has_vehicle = any(d["label"] in vehicle_objects for d in detections)
        has_backpack = any(d["label"] in ["backpack", "suitcase"] for d in detections)
        person_count = sum(1 for d in detections if d["label"] == "person")

        # Only map classes that COCO can actually detect as objects
        if has_weapon:
            best = max((d["confidence"] for d in detections if d["label"] in weapon_objects), default=0.9)
            return {"label": "weapon_detected", "confidence": round(best, 3)}
        if has_backpack and person_count == 0:
            return {"label": "suspicious_package", "confidence": 0.83}
        if has_vehicle and person_count == 0:
            return {"label": "vehicle_intrusion", "confidence": 0.82}
        if person_count >= 1 and self._check_person_down(detections):
            return {"label": "person_down", "confidence": 0.75}

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
            "robbery", "intrusion_detected", "violence",
        ]
        medium = [
            "vehicle_intrusion", "suspicious_package",
        ]
        low = []

        if label in high:
            return "high"
        elif label in medium:
            return "medium"
        elif label in low:
            return "low"
        return "low"