from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Explosion",
        audio_label="explosion",
        visual_label="person_down",
        expected_severity="high",
    )