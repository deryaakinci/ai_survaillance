from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Explosion",
        audio_label="impact",
        visual_label="explosion",
        expected_severity="high",
    )