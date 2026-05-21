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
    "car_crash",
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
MIN_CONFIDENCE = 0.45


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
        # baseball bat) as an additional detection layer on top of our
        # fine-tuned models.
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
        # ── Step 1: ResNet18 scene classification (primary) ─────────
        resnet_result = self._run_resnet(frame)

        # ── Step 2: COCO weapon object scan (supplementary) ─────────
        # Only fires if base YOLO physically detects a knife/scissors/bat.
        # If ResNet strongly says "normal", we override — prevents false
        # positives on benign footage (e.g. weather reports).
        weapon_hit = self._run_weapon_scan(frame)

        if weapon_hit is not None:
            r_label = resnet_result["label"] if resnet_result else "normal"
            r_conf = resnet_result["confidence"] if resnet_result else 0.0

            # Trust COCO if ResNet also sees a threat, or ResNet is unsure
            if r_label != "normal" or r_conf < 0.60:
                return weapon_hit
            # ResNet confidently says normal → ignore COCO false positive
            # (common with weather graphics, kitchen scenes, etc.)

        # ── Step 3: Return ResNet result ────────────────────────────
        if resnet_result is None:
            return {"label": "normal", "confidence": 0.0}

        # If undetermined (low confidence), treat as normal
        if resnet_result["label"] != "normal" and resnet_result["confidence"] < MIN_CONFIDENCE:
            return {"label": "normal", "confidence": round(1.0 - resnet_result["confidence"], 3)}

        return resnet_result

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
            # Only consider 2nd-best anomaly if the model is genuinely uncertain
            # (top1 normal confidence is low) AND the anomaly is fairly certain.
            if top1_conf < 0.45 and top2_label != "normal" and top2_conf > 0.40:
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

        # YOLO weapon detection — require ResNet agreement or high YOLO confidence
        if y_label == "weapon_detected":
            if r_label == "weapon_detected":
                return {"label": "weapon_detected", "confidence": round(min(max(y_conf, r_conf) * 1.15, 0.99), 3)}
            if y_conf >= 0.70:
                return {"label": "weapon_detected", "confidence": round(y_conf, 3)}

        # Both agree → strong confidence boost
        if y_label == r_label:
            return {"label": y_label, "confidence": round(min(max(y_conf, r_conf) * 1.15, 0.99), 3)}

        # Both flag an anomaly but DISAGREE on class → heavy penalty.
        # When models disagree, it's usually OOD confusion (e.g. weather
        # report misclassified).  Real threats make both models agree.
        # Audio cross-modal fusion handles cases where visual can't
        # classify the scene but audio detects the threat.
        if y_label != "normal" and r_label != "normal":
            weaker_conf = min(y_conf, r_conf)
            return {"label": y_label, "confidence": round(weaker_conf * 0.35, 3)}

        # Only YOLO fires, ResNet says normal → be very skeptical.
        # The fine-tuned YOLO was trained with full-frame bounding boxes,
        # so it tends to always output a detection.  ResNet is the proper
        # scene classifier — trust its "normal" verdict.
        if y_label != "normal":
            return {"label": "normal", "confidence": round(max(r_conf, 1.0 - y_conf), 3)}

        # Only ResNet18 fires → moderate trust (scene classifier is better
        # but still prone to OOD mistakes when acting alone).
        if r_label != "normal":
            if r_conf >= 0.70:
                return {"label": r_label, "confidence": round(r_conf * 0.75, 3)}
            return {"label": "normal", "confidence": round(1.0 - r_conf, 3)}

        return {"label": "normal", "confidence": round(max(y_conf, r_conf), 3)}

    def _predict_finetuned(self, results) -> dict:
        """
        Fine-tuned YOLO model outputs our custom surveillance labels directly.
        High-priority labels only override when they have meaningful confidence
        (>= 0.50).  Otherwise, prefer the highest-confidence detection.
        """
        best_label = None
        best_score = 0.0
        high_prio_label = None
        high_prio_score = 0.0

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

                # Track best overall detection
                if confidence > best_score:
                    best_label = label
                    best_score = confidence

                # Track best high-priority detection separately
                if label in self.HIGH_PRIORITY_LABELS and confidence > high_prio_score:
                    high_prio_label = label
                    high_prio_score = confidence

        # High-priority only wins if it has meaningful confidence (>= 0.50)
        if high_prio_label is not None and high_prio_score >= 0.50:
            return {
                "label": high_prio_label,
                "confidence": round(high_prio_score, 3),
            }
        # Otherwise use highest-confidence detection regardless of priority
        if best_label is not None:
            return {
                "label": best_label,
                "confidence": round(best_score, 3),
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
            return {"label": "car_crash", "confidence": 0.82}
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

    _IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".bmp", ".webp", ".tiff", ".tif"}

    def predict_from_file(self, file_path: str) -> dict:
        try:
            ext = os.path.splitext(file_path)[1].lower()
            if ext in self._IMAGE_EXTENSIONS:
                frame = cv2.imread(file_path)
                if frame is not None:
                    return self.predict(frame)
                return {"label": "normal", "confidence": 0.0}
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
            "car_crash", "suspicious_package",
        ]
        low = []

        if label in high:
            return "high"
        elif label in medium:
            return "medium"
        elif label in low:
            return "low"
        return "low"