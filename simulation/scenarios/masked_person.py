import numpy as np

def simulate():
    return {
        "name": "Masked person",
        "audio": np.random.uniform(0.01, 0.03, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "masked_person", "confidence": 0.87, "detections": [], "person_count": 1},
        "expected_severity": "high",
    }