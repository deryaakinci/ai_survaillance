import numpy as np

def simulate():
    return {
        "name": "Suspicious package",
        "audio": np.random.uniform(0.01, 0.02, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "suspicious_package", "confidence": 0.83, "detections": [], "person_count": 0},
        "expected_severity": "medium",
    }