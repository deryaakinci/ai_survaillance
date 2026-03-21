import numpy as np

def simulate():
    return {
        "name": "Crying distress",
        "audio": np.random.uniform(0.03, 0.06, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "person_down", "confidence": 0.82, "detections": [], "person_count": 1},
        "expected_severity": "medium",
    }