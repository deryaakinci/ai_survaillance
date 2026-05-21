from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Siren",
        audio_label="siren",
        visual_label="car_crash",
        expected_severity="low",
    )