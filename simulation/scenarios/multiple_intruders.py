import numpy as np

def simulate():
    return {
        "name": "Multiple intruders",
        "audio": np.random.uniform(0.02, 0.05, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "multiple_intruders", "confidence": 0.92, "detections": [], "person_count": 3},
        "expected_severity": "high",
    }