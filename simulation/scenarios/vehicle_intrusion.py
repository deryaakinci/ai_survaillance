from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Vehicle intrusion",
        audio_label="normal",
        visual_label="vehicle_intrusion",
        expected_severity="medium",
    )