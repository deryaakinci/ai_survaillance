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
FALLBACK_MODEL_PATH   = "yolov8n.pt"

# Minimum confidence to report an anomaly — below this we say "normal"
MIN_CONFIDENCE = 0.55


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
    _WEAPON_REQUIRED_FRAMES = 3

    def __init__(self):
        self.resnet  = None
        self.yolo    = None
        self.yolo_base = None
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
            print(f"[VisualAnomalyDetector] ResNet18 loaded from {CLASSIFIER_MODEL_PATH}")
        else:
            print("[VisualAnomalyDetector] ResNet18 not found — run train_visual_classifier.py")

        # ── Load base YOLO for COCO knife detection ───────────────────
        # try:
        #     from ultralytics import YOLO as _YOLO
        #     self.yolo_base = _YOLO(FALLBACK_MODEL_PATH)
        #     print("[VisualAnomalyDetector] Base YOLO loaded for COCO knife detection")
        #
        #     if os.path.exists(FINETUNED_YOLO_PATH):
        #         self.yolo = _YOLO(FINETUNED_YOLO_PATH)
        #         print(f"[VisualAnomalyDetector] Fine-tuned YOLO loaded from {FINETUNED_YOLO_PATH}")
        # except ImportError:
        #     print("[VisualAnomalyDetector] ultralytics not installed — YOLO knife detection unavailable")

    # ── Public entry point ────────────────────────────────────────────

    def predict(self, frame) -> dict:
        resnet_result = self._run_resnet_tta(frame)
        # weapon_hit  = self._run_weapon_scan(frame)  # YOLO knife detection
        weapon_hit    = None

        r_label = resnet_result["label"]       if resnet_result else "normal"
        r_conf  = resnet_result["confidence"]  if resnet_result else 0.0

        # YOLO knife hit: suppress only when ResNet is confidently normal
        # and we haven't built a streak yet (kitchen-scene false-positive guard).
        yolo_weapon = (
            weapon_hit is not None
            and not (r_label == "normal" and r_conf >= 0.45
                     and self._weapon_streak < self._WEAPON_REQUIRED_FRAMES)
        )
        # Classifier weapon hit: covers guns and any weapon the model learned.
        classifier_weapon = (r_label == "weapon_detected" and r_conf >= MIN_CONFIDENCE)

        if yolo_weapon or classifier_weapon:
            conf = max(
                weapon_hit["confidence"] if yolo_weapon and weapon_hit else 0.0,
                r_conf if classifier_weapon else 0.0,
            )
            self._weapon_streak += 1
            if self._weapon_streak >= self._WEAPON_REQUIRED_FRAMES:
                return {"label": "weapon_detected", "confidence": round(conf, 3)}
            return {"label": "normal", "confidence": round(1.0 - conf, 3)}

        self._weapon_streak = 0

        if resnet_result is None:
            return {"label": "normal", "confidence": 0.0}

        # Classifier said weapon_detected but didn't meet confidence threshold — suppress.
        if r_label == "weapon_detected":
            return {"label": "normal", "confidence": round(1.0 - r_conf, 3)}

        if r_label != "normal" and r_conf < MIN_CONFIDENCE:
            return {"label": "normal", "confidence": round(1.0 - r_conf, 3)}

        return resnet_result


    def _run_weapon_scan(self, frame) -> dict | None:
        """Use base YOLO (COCO-pretrained) to detect weapons.
        This preserves YOLO's strong weapon knowledge even after fine-tuning.
        Only fires on high-confidence knife detections to avoid FPs."""
        if self.yolo_base is None:
            return None

        results = self.yolo_base(frame, verbose=False, conf=0.55)

        best_conf = 0.0
        for result in results:
            for box in result.boxes:
                cls_id = int(box.cls[0])
                label = self.yolo_base.names[cls_id]
                confidence = float(box.conf[0])
                if label in self.WEAPON_COCO_LABELS and confidence > best_conf:
                    best_conf = confidence

        if best_conf > 0.55:
           
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
           
            if top1_conf < 0.40 and top2_label != "normal" and top2_conf > MIN_CONFIDENCE:
                return {"label": top2_label, "confidence": round(top2_conf * 0.85, 3)}
            return {"label": "normal", "confidence": round(top1_conf, 3)}

        if top1_conf < MIN_CONFIDENCE:
            return {"label": "normal", "confidence": round(1.0 - top1_conf, 3)}

        return {"label": top1_label, "confidence": round(top1_conf, 3)}

    def _run_resnet_tta(self, frame) -> dict | None:
        """Test-Time Augmentation: average softmax over 5 views for robustness.

        Views: original, horizontal flip, two corner crops, slight rotation.
        Breaks ties on ambiguous classes (robbery/intrusion, weapon/normal).
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
            probs = torch.softmax(output, dim=1)
            avg_probs = probs.mean(dim=0, keepdim=True)

        top2_probs, top2_idx = avg_probs.topk(2, dim=1)
        top1_conf  = float(top2_probs[0][0])
        top1_label = LABELS[int(top2_idx[0][0])]
        top2_conf  = float(top2_probs[0][1])
        top2_label = LABELS[int(top2_idx[0][1])]

        if top1_label == "normal":
            if top1_conf < 0.40 and top2_label != "normal" and top2_conf > MIN_CONFIDENCE:
                return {"label": top2_label, "confidence": round(top2_conf * 0.85, 3)}
            return {"label": "normal", "confidence": round(top1_conf, 3)}

        if top1_conf < MIN_CONFIDENCE:
            return {"label": "normal", "confidence": round(1.0 - top1_conf, 3)}

        return {"label": top1_label, "confidence": round(top1_conf, 3)}


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