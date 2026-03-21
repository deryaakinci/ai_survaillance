import numpy as np

def simulate():
    return {
        "name": "Explosion",
        "audio": np.random.uniform(0.10, 0.30, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "multiple_intruders", "confidence": 0.90, "detections": [], "person_count": 3},
        "expected_severity": "high",
    }