from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Loitering",
        audio_label="normal",
        visual_label="loitering",
        expected_severity="low",
    )