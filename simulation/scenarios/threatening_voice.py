from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Threatening voice",
        audio_label="threatening_voice",
        visual_label="masked_person",
        expected_severity="high",
    )