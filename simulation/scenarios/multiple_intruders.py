from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Multiple intruders",
        audio_label="fight_sounds",
        visual_label="multiple_intruders",
        expected_severity="high",
    )