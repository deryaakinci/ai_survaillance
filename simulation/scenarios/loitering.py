import numpy as np

def simulate():
    return {
        "name": "Loitering",
        "audio": np.random.uniform(0.005, 0.01, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "loitering", "confidence": 0.78, "detections": [], "person_count": 1},
        "expected_severity": "low",
    }