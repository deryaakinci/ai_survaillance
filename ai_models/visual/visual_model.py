import cv2
import numpy as np
from ultralytics import YOLO


class VisualAnomalyDetector:
    def __init__(self):
        self.model = YOLO("yolov8n.pt")

        self.weapon_objects = [
            "knife",
            "gun",
            "scissors",
            "baseball bat",
        ]

        self.vehicle_objects = [
            "car",
            "motorcycle",
            "truck",
            "bus",
        ]

        self.activity_labels = [
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

    def predict(self, frame):
        results = self.model(frame, verbose=False)
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

        return self._analyze_scene(frame, detections)

    def _analyze_scene(self, frame, detections):
        if not detections:
            return {
                "label": "normal",
                "confidence": 0.95,
                "detections": [],
                "person_count": 0,
            }

        person_count = sum(
            1 for d in detections if d["label"] == "person"
        )
        has_weapon = any(
            d["label"] in self.weapon_objects for d in detections
        )
        has_vehicle = any(
            d["label"] in self.vehicle_objects for d in detections
        )
        has_backpack = any(
            d["label"] == "backpack" for d in detections
        )

        # Check for dark/low visibility — potential masked person
        is_dark = self._check_low_light(frame)

        # Weapon detected — critical priority
        if has_weapon:
            return {
                "label": "weapon_detected",
                "confidence": 0.98,
                "detections": detections,
                "person_count": person_count,
            }

        # Person down on ground — emergency
        if person_count >= 1 and self._check_person_down(detections, frame):
            return {
                "label": "person_down",
                "confidence": 0.91,
                "detections": detections,
                "person_count": person_count,
            }

        # Crowd — 4 or more people
        if person_count >= 4:
            return {
                "label": "crowd_detected",
                "confidence": round(
                    min(0.70 + person_count * 0.05, 0.97), 3
                ),
                "detections": detections,
                "person_count": person_count,
            }

        # Multiple intruders — 2 or 3 people
        if person_count in [2, 3]:
            return {
                "label": "multiple_intruders",
                "confidence": round(
                    min(0.65 + person_count * 0.07, 0.95), 3
                ),
                "detections": detections,
                "person_count": person_count,
            }

        # Single person in low light — masked or suspicious
        if person_count == 1 and is_dark:
            return {
                "label": "masked_person",
                "confidence": 0.87,
                "detections": detections,
                "person_count": person_count,
            }

        # Single intruder
        if person_count == 1:
            return {
                "label": "intruder_detected",
                "confidence": 0.88,
                "detections": detections,
                "person_count": person_count,
            }

        # Suspicious package — unattended backpack no person
        if has_backpack and person_count == 0:
            return {
                "label": "suspicious_package",
                "confidence": 0.83,
                "detections": detections,
                "person_count": 0,
            }

        # Vehicle without person
        if has_vehicle and person_count == 0:
            return {
                "label": "vehicle_intrusion",
                "confidence": 0.82,
                "detections": detections,
                "person_count": 0,
            }

        return {
            "label": "normal",
            "confidence": 0.90,
            "detections": detections,
            "person_count": person_count,
        }

    def _check_low_light(self, frame) -> bool:
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        return float(np.mean(gray)) < 60.0

    def _check_person_down(self, detections, frame) -> bool:
        for d in detections:
            if d["label"] == "person":
                bbox = d["bbox"]
                width = bbox[2] - bbox[0]
                height = bbox[3] - bbox[1]
                # Person is horizontal if width > height
                if width > height * 1.5:
                    return True
        return False

    def predict_from_file(self, file_path: str):
        try:
            cap = cv2.VideoCapture(file_path)
            ret, frame = cap.read()
            cap.release()
            if ret:
                return self.predict(frame)
            return {"label": "normal", "confidence": 0.0}
        except Exception as e:
            return {
                "label": "normal",
                "confidence": 0.0,
                "error": str(e),
            }

    def get_severity(self, label: str) -> str:
        high = [
            "weapon_detected",
            "person_down",
            "multiple_intruders",
            "masked_person",
            "forced_entry",
        ]
        medium = [
            "intruder_detected",
            "crowd_detected",
            "vehicle_intrusion",
            "fighting",
            "suspicious_package",
        ]
        low = [
            "loitering",
        ]

        if label in high:
            return "high"
        elif label in medium:
            return "medium"
        elif label in low:
            return "low"
        return "low"