from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Abuse",
        audio_label="screaming",
        visual_label="abuse",
        expected_severity="high",
    )