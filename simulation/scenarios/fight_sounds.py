import numpy as np

def simulate():
    return {
        "name": "Fight sounds",
        "audio": np.random.uniform(0.06, 0.14, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "fighting", "confidence": 0.86, "detections": [], "person_count": 2},
        "expected_severity": "high",
    }