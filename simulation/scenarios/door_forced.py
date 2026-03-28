from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Door forced",
        audio_label="door_forced",
        visual_label="forced_entry",
        expected_severity="high",
    )