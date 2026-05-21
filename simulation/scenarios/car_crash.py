from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Car crash",
        audio_label="impact",
        visual_label="car_crash",
        expected_severity="medium",
    )