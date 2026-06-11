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
    "person_down",
    "intrusion_detected",
]

CLASSIFIER_MODEL_PATH = "ai_models/visual/saved_model/best_classifier.pth"
FINETUNED_YOLO_PATH   = "ai_models/visual/saved_model/surveillance_model/weights/best.pt"
WEAPON_YOLO_PATH      = "ai_models/visual/saved_model/weapon_detector/weights/best.pt"
FALLBACK_MODEL_PATH   = "yolov8n.pt"

# Default minimum confidence to report an anomaly
MIN_CONFIDENCE = 0.55
# Per-class overrides — lower thresholds improve recall for classes that co-occur
# with dominant scenes (e.g. violence alongside weapon_detected where weapon
# saturates at 0.96 and suppresses the violence activation to ~0.48-0.54).
CLASS_THRESHOLDS = {
    "violence": 0.35,
}

# Priority order for multi-label: most critical threats reported first
PRIORITY_ORDER = [
    "weapon_detected", "explosion", "person_down",
    "violence", "intrusion_detected", "car_crash",
]


# ── ImageNet normalisation (must match training) ──────────────────────
IMAGENET_MEAN = [0.485, 0.456, 0.406]
IMAGENET_STD  = [0.229, 0.224, 0.225]

_inference_transform = transforms.Compose([
    transforms.Resize((332, 332)),
    transforms.CenterCrop(300),
    transforms.ToTensor(),
    transforms.Normalize(IMAGENET_MEAN, IMAGENET_STD),
])


def _build_classifier(num_classes: int):
    """Must exactly match the head in train_visual_classifier.py."""
    model = models.efficientnet_v2_s(weights=None)
    in_features = model.classifier[1].in_features  # 1280 for EfficientNet-V2-S
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


class VisualAnomalyDetector:

    WEAPON_COCO_LABELS = {"knife"}

    HIGH_PRIORITY_LABELS = {
        "weapon_detected", "explosion", "person_down",
        "intrusion_detected", "violence",
    }

    # Consecutive frames weapon_detected must appear before firing the alert.
    # Eliminates single-frame FPs from scene context without blocking real threats.
    _WEAPON_REQUIRED_FRAMES = 2

    def __init__(self, debug: bool = False):
        self.debug       = debug
        self.resnet      = None
        self.yolo        = None
        self.yolo_base   = None
        self.weapon_yolo = None
        self._weapon_streak = 0
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
            print(f"[VisualAnomalyDetector] EfficientNet-V2-S loaded from {CLASSIFIER_MODEL_PATH}")
        else:
            print("[VisualAnomalyDetector] EfficientNet-V2-S not found — run train_visual_classifier.py")

        # ── Load YOLO models ──────────────────────────────────────────
        try:
            from ultralytics import YOLO as _YOLO
            self.yolo_base = _YOLO(FALLBACK_MODEL_PATH)
            print("[VisualAnomalyDetector] Base YOLO loaded (COCO knife detection)")

            # Dedicated weapon detector (guns + knives) — train with:
            #   yolo detect train model=yolov8n.pt data=weapon_data.yaml epochs=50
            if os.path.exists(WEAPON_YOLO_PATH):
                self.weapon_yolo = _YOLO(WEAPON_YOLO_PATH)
                print(f"[VisualAnomalyDetector] Weapon YOLO loaded from {WEAPON_YOLO_PATH}")
            else:
                print("[VisualAnomalyDetector] No weapon YOLO found — gun detection via EfficientNet only")

            if os.path.exists(FINETUNED_YOLO_PATH):
                self.yolo = _YOLO(FINETUNED_YOLO_PATH)
                print(f"[VisualAnomalyDetector] Fine-tuned YOLO loaded from {FINETUNED_YOLO_PATH}")
        except ImportError:
            print("[VisualAnomalyDetector] ultralytics not installed — YOLO unavailable")

    # ── Public entry point ────────────────────────────────────────────

    def is_ready(self) -> bool:
        """
        Returns True if the visual model has at least the EfficientNet
        classifier loaded and is capable of meaningful inference.
        Returns False when running in a degraded / model-not-found state.
        """
        return self.resnet is not None

    def predict(self, frame) -> dict:
        resnet_result = self._run_resnet_tta(frame)
        weapon_hit    = self._run_weapon_scan(frame)

        detections = resnet_result.get("detections", []) if resnet_result else []

        # YOLO is the sole weapon authority. The 3-frame streak is the false-positive
        # guard — no additional suppression needed with a dedicated trained model.
        yolo_weapon = weapon_hit is not None

        if yolo_weapon:
            conf = weapon_hit["confidence"]
            self._weapon_streak += 1
            if self._weapon_streak >= self._WEAPON_REQUIRED_FRAMES:
                result = {"label": "weapon_detected", "confidence": round(conf, 3)}
                if detections:
                    result["detections"] = [("weapon_detected", round(conf, 3))] + detections
                return result
            # Streak building — surface whatever scene EfficientNet sees
            if detections:
                result = {"label": detections[0][0], "confidence": round(detections[0][1], 3)}
                if len(detections) > 1:
                    result["detections"] = detections
                return result
            return {"label": "normal", "confidence": round(1.0 - conf, 3)}

        self._weapon_streak = 0

        if resnet_result is None:
            return {"label": "normal", "confidence": 0.0}

        if resnet_result["label"] == "normal":
            return {"label": "normal", "confidence": resnet_result["confidence"]}

        return resnet_result


    def _run_weapon_scan(self, frame) -> dict | None:
        """Detect weapons (guns + knives) using available YOLO models.

        Priority:
          1. Dedicated weapon YOLO (guns + knives) — used when trained and available
          2. Base COCO YOLO — knife-only fallback
        """
        # ── 1. Dedicated weapon detector (guns + knives) ──────────────
        if self.weapon_yolo is not None:
            # Use a lower detection floor (0.35) to handle low-quality or
            # distant frames where YOLO confidence is compressed but the
            # weapon is genuinely present. The 2-frame streak in predict()
            # acts as the false-positive guard.
            results = self.weapon_yolo(frame, verbose=False, conf=0.35)
            best_conf = 0.0
            for result in results:
                for box in result.boxes:
                    confidence = float(box.conf[0])
                    if confidence > best_conf:
                        best_conf = confidence
            if best_conf >= 0.35:
                return {"label": "weapon_detected", "confidence": round(best_conf, 3)}
            return None

        # ── 2. Base COCO YOLO — knife only ────────────────────────────
        if self.yolo_base is None:
            return None

        results = self.yolo_base(frame, verbose=False, conf=0.50)
        best_conf = 0.0
        for result in results:
            for box in result.boxes:
                cls_id = int(box.cls[0])
                label = self.yolo_base.names[cls_id]
                confidence = float(box.conf[0])
                if label in self.WEAPON_COCO_LABELS and confidence > best_conf:
                    best_conf = confidence

        if best_conf >= 0.50:
            return {"label": "weapon_detected", "confidence": round(best_conf, 3)}

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
        """Single-view classifier inference (no TTA)."""
        if self.resnet is None:
            return None

        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        img = Image.fromarray(frame_rgb)
        tensor = _inference_transform(img).unsqueeze(0).to(self.device)

        with torch.no_grad():
            output = self.resnet(tensor)
            probs = torch.sigmoid(output)

        avg_probs = probs[0]  # (NUM_CLASSES,)

        normal_conf = float(avg_probs[LABELS.index("normal")])

        # Multi-label: find all anomaly classes above their per-class threshold.
        # weapon_detected is excluded — YOLO is the sole weapon authority.
        active_anomalies = []
        for i, label in enumerate(LABELS):
            if label in ("normal", "weapon_detected"):
                continue
            conf = float(avg_probs[i])
            threshold = CLASS_THRESHOLDS.get(label, MIN_CONFIDENCE)
            if conf >= threshold:
                active_anomalies.append((label, conf))

        if active_anomalies:
            active_anomalies.sort(
                key=lambda x: PRIORITY_ORDER.index(x[0]) if x[0] in PRIORITY_ORDER else 99
            )
            primary_label, primary_conf = active_anomalies[0]
            highest_conf = max(c for _, c in active_anomalies)
            if primary_conf < highest_conf - 0.15:
                active_anomalies.sort(key=lambda x: x[1], reverse=True)
                primary_label, primary_conf = active_anomalies[0]
            if primary_conf <= normal_conf:
                return {"label": "normal", "confidence": round(normal_conf, 3)}
            return {
                "label": primary_label,
                "confidence": round(primary_conf, 3),
                "detections": [(l, round(c, 3)) for l, c in active_anomalies],
            }

        return {"label": "normal", "confidence": round(normal_conf, 3)}

    def _run_resnet_tta(self, frame) -> dict | None:
        """Test-Time Augmentation: average sigmoid over 5 views for robustness.

        Views: original, horizontal flip, two corner crops, slight rotation.
        Multi-label: each class fires independently via sigmoid.  Returns the
        highest-priority anomaly class above MIN_CONFIDENCE threshold.
        """
        if self.resnet is None:
            return None

        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        img = Image.fromarray(frame_rgb)

        # Build 5 augmented views
        views = [_inference_transform(img)]
        views.append(_inference_transform(img.transpose(Image.FLIP_LEFT_RIGHT)))
        w, h = img.size
        margin_w, margin_h = int(w * 0.06), int(h * 0.06)
        views.append(_inference_transform(img.crop((margin_w, margin_h, w, h))))
        views.append(_inference_transform(img.crop((0, 0, w - margin_w, h - margin_h))))
        views.append(_inference_transform(img.rotate(5, expand=False, fillcolor=(128, 128, 128))))

        batch = torch.stack(views).to(self.device)

        with torch.no_grad():
            output = self.resnet(batch)
            probs = torch.sigmoid(output)
            avg_probs = probs.mean(dim=0)  # (NUM_CLASSES,)

        normal_conf = float(avg_probs[LABELS.index("normal")])

        if self.debug:
            print("[TTA probs]", {
                label: f"{float(avg_probs[i]):.3f}"
                for i, label in enumerate(LABELS)
            })

        # Multi-label: find all anomaly classes above their per-class threshold.
        # weapon_detected is excluded — YOLO is the sole weapon authority.
        active_anomalies = []
        for i, label in enumerate(LABELS):
            if label in ("normal", "weapon_detected"):
                continue
            conf = float(avg_probs[i])
            threshold = CLASS_THRESHOLDS.get(label, MIN_CONFIDENCE)
            if conf >= threshold:
                active_anomalies.append((label, conf))

        if active_anomalies:
            active_anomalies.sort(
                key=lambda x: PRIORITY_ORDER.index(x[0]) if x[0] in PRIORITY_ORDER else 99
            )
            primary_label, primary_conf = active_anomalies[0]
            highest_conf = max(c for _, c in active_anomalies)
            if primary_conf < highest_conf - 0.15:
                active_anomalies.sort(key=lambda x: x[1], reverse=True)
                primary_label, primary_conf = active_anomalies[0]
            if primary_conf <= normal_conf:
                return {"label": "normal", "confidence": round(normal_conf, 3)}
            return {
                "label": primary_label,
                "confidence": round(primary_conf, 3),
                "detections": [(l, round(c, 3)) for l, c in active_anomalies],
            }

        return {"label": "normal", "confidence": round(normal_conf, 3)}


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

     
        if y_label != "normal" and r_label != "normal":
            weaker_conf = min(y_conf, r_conf)
            return {"label": y_label, "confidence": round(weaker_conf * 0.35, 3)}

 
        if y_label != "normal":
            return {"label": "normal", "confidence": round(max(r_conf, 1.0 - y_conf), 3)}


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
        violence, explosion are left to the fine-tuned model
        and ResNet since COCO cannot detect actions.
        """
     
        weapon_objects = ["knife"]
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
            # Logic-based: unattended bag → suspicious (moderate confidence)
            return {"label": "suspicious_package", "confidence": 0.65}
        if has_vehicle and person_count == 0:
          
            return {"label": "car_crash", "confidence": 0.60}
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
                self._weapon_streak = self._WEAPON_REQUIRED_FRAMES  # bypass streak gate for images
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
            "intrusion_detected", "violence",
        ]
        medium = [
            "car_crash",
            # suspicious_package severity is handled by fusion engine
        ]
        low = []

        if label in high:
            return "high"
        elif label in medium:
            return "medium"
        elif label in low:
            return "low"
        return "low"