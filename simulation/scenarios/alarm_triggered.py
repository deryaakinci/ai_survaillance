from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Alarm triggered",
        audio_label="alarm_triggered",
        visual_label="intruder_detected",
        expected_severity="medium",
    )