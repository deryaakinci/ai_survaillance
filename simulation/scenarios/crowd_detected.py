from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Crowd detected",
        audio_label="fight_sounds",
        visual_label="crowd_detected",
        expected_severity="medium",
    )