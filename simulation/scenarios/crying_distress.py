from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Crying distress",
        audio_label="distress_sounds",
        visual_label="intrusion_detected",
        expected_severity="medium",
    )