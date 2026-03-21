import numpy as np

def simulate():
    return {
        "name": "Fighting",
        "audio": np.random.uniform(0.05, 0.12, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "fighting", "confidence": 0.89, "detections": [], "person_count": 2},
        "expected_severity": "high",
    }