from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Normal",
        audio_label="normal",
        visual_label="normal",
        expected_severity="low",
    )