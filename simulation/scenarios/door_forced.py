import numpy as np

def simulate():
    return {
        "name": "Door forced",
        "audio": np.random.uniform(0.08, 0.20, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "forced_entry", "confidence": 0.89, "detections": [], "person_count": 1},
        "expected_severity": "high",
    }