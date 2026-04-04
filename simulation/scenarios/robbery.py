from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Masked person",
        audio_label="threatening_voice",
        visual_label="robbery",
        expected_severity="high",
    )