import numpy as np

def simulate():
    return {
        "name": "Vehicle intrusion",
        "audio": np.random.uniform(0.03, 0.06, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "vehicle_intrusion", "confidence": 0.82, "detections": [], "person_count": 0},
        "expected_severity": "medium",
    }