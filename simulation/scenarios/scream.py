import numpy as np

def simulate():
    return {
        "name": "Scream",
        "audio": np.random.uniform(0.06, 0.15, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "person_down", "confidence": 0.91, "detections": [], "person_count": 1},
        "expected_severity": "high",
    }