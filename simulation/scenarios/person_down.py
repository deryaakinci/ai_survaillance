import numpy as np

def simulate():
    return {
        "name": "Person down",
        "audio": np.random.uniform(0.02, 0.04, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "person_down", "confidence": 0.91, "detections": [], "person_count": 1},
        "expected_severity": "high",
    }