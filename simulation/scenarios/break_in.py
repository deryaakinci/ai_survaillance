from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Break in",
        audio_label="break_in",
        visual_label="forced_entry",
        expected_severity="medium",
    )