from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Scream",
        audio_label="scream",
        visual_label="intruder_detected",
        expected_severity="high",
    )