import numpy as np

def simulate():
    return {
        "name": "Break in",
        "audio": np.random.uniform(0.05, 0.08, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "intruder_detected", "confidence": 0.87, "detections": [], "person_count": 1},
        "expected_severity": "medium",
    }