from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Fighting",
        audio_label="fight_sounds",
        visual_label="violence",
        expected_severity="high",
    )