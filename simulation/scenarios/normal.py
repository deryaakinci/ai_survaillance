import numpy as np

def simulate():
    return {
        "name": "Normal",
        "audio": np.random.uniform(0.001, 0.005, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "normal", "confidence": 0.95, "detections": [], "person_count": 0},
        "expected_severity": "none",
    }