import numpy as np

def simulate():
    return {
        "name": "Threatening voice",
        "audio": np.random.uniform(0.04, 0.06, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "intruder_detected", "confidence": 0.80, "detections": [], "person_count": 1},
        "expected_severity": "high",
    }