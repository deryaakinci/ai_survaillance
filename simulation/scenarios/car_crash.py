import numpy as np

def simulate():
    return {
        "name": "Car crash",
        "audio": np.random.uniform(0.07, 0.18, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "vehicle_intrusion", "confidence": 0.85, "detections": [], "person_count": 0},
        "expected_severity": "medium",
    }