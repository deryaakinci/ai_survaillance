import numpy as np

def simulate():
    return {
        "name": "Intruder detected",
        "audio": np.random.uniform(0.01, 0.03, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "intruder_detected", "confidence": 0.88, "detections": [], "person_count": 1},
        "expected_severity": "medium",
    }