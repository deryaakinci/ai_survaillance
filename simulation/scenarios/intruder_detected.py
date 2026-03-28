from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Intruder detected",
        audio_label="normal",
        visual_label="intruder_detected",
        expected_severity="medium",
    )