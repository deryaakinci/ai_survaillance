import cv2
import numpy as np
from ultralytics import YOLO
import os


LABELS = [
    "normal",
    "intruder_detected",
    "weapon_detected",
    "multiple_intruders",
    "vehicle_intrusion",
    "loitering",
    "fighting",
    "crowd_detected",
    "masked_person",
    "person_down",
    "forced_entry",
    "suspicious_package",
]

FINETUNED_MODEL_PATH = (
    "ai_models/visual/saved_model/surveillance_model/weights/best.pt"
)
FALLBACK_MODEL_PATH = "yolov8n.pt"


class VisualAnomalyDetector:
    def __init__(self):
        self.is_finetuned = False

        if os.path.exists(FINETUNED_MODEL_PATH):
            self.model = YOLO(FINETUNED_MODEL_PATH)
            self.is_finetuned = True
            print(
                f"[VisualAnomalyDetector] Fine-tuned model loaded from {FINETUNED_MODEL_PATH}"
            )
        else:
            self.model = YOLO(FALLBACK_MODEL_PATH)
            print(
                "[VisualAnomalyDetector] Fine-tuned model not found — "
                "using base yolov8n.pt. Run train_visual_model.py first."
            )

    def predict(self, frame) -> dict:
        results = self.model(frame, verbose=False)

        if self.is_finetuned:
            return self._predict_finetuned(results)
        else:
            return self._predict_base(frame, results)

    def _predict_finetuned(self, results) -> dict:
        """
        Fine-tuned model outputs our custom surveillance labels directly.
        Pick the detection with the highest confidence.
        """
        best_label = "normal"
        best_confidence = 0.95  # default when nothing detected

        for result in results:
            for box in result.boxes:
                confidence = float(box.conf[0])
                cls_id = int(box.cls[0])
                label = (
                    LABELS[cls_id]
                    if cls_id < len(LABELS)
                    else "normal"
                )
                if confidence > best_confidence and label != "normal":
                    best_label = label
                    best_confidence = confidence

        return {
            "label": best_label,
            "confidence": round(best_confidence, 3),
        }

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
            return {"label": "crowd_detected", "confidence": round(min(0.70 + person_count * 0.05, 0.97), 3)}
        if person_count in [2, 3]:
            return {"label": "multiple_intruders", "confidence": round(min(0.65 + person_count * 0.07, 0.95), 3)}
        if person_count == 1 and is_dark:
            return {"label": "masked_person", "confidence": 0.87}
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
            "weapon_detected", "person_down", "multiple_intruders",
            "masked_person", "forced_entry",
        ]
        medium = [
            "intruder_detected", "crowd_detected", "vehicle_intrusion",
            "fighting", "suspicious_package",
        ]
        low = ["loitering"]

        if label in high:
            return "high"
        elif label in medium:
            return "medium"
        elif label in low:
            return "low"
        return "low"