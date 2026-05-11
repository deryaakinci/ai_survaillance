from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Scream",
        audio_label="distress_sounds",
        visual_label="intrusion_detected",
        expected_severity="high",
    )