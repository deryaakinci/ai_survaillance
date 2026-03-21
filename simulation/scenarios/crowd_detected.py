import numpy as np

def simulate():
    return {
        "name": "Crowd detected",
        "audio": np.random.uniform(0.03, 0.07, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "crowd_detected", "confidence": 0.85, "detections": [], "person_count": 5},
        "expected_severity": "medium",
    }