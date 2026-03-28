from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Fight sounds",
        audio_label="fight_sounds",
        visual_label="fighting",
        expected_severity="high",
    )