import numpy as np

def simulate():
    return {
        "name": "Weapon detected",
        "audio": np.random.uniform(0.01, 0.02, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "weapon_detected", "confidence": 0.97, "detections": [], "person_count": 1},
        "expected_severity": "high",
    }