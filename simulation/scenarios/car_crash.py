from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Car crash",
        audio_label="car_crash",
        visual_label="vehicle_intrusion",
        expected_severity="medium",
    )