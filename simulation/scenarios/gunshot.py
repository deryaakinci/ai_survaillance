from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Gunshot",
        audio_label="gunshot",
        visual_label="person_down",
        expected_severity="high",
    )