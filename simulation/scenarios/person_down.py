from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Person down",
        audio_label="scream",
        visual_label="person_down",
        expected_severity="high",
    )