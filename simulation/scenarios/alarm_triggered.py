import numpy as np

def simulate():
    return {
        "name": "Alarm triggered",
        "audio": np.random.uniform(0.04, 0.07, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "intruder_detected", "confidence": 0.83, "detections": [], "person_count": 1},
        "expected_severity": "medium",
    }