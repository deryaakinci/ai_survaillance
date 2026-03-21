import numpy as np

def simulate():
    return {
        "name": "Glass break",
        "audio": np.random.uniform(0.07, 0.18, 22050).astype(np.float32),
        "sr": 22050,
        "visual": {"label": "forced_entry", "confidence": 0.85, "detections": [], "person_count": 1},
        "expected_severity": "medium",
    }