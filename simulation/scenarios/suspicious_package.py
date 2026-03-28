from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Suspicious package",
        audio_label="normal",
        visual_label="suspicious_package",
        expected_severity="medium",
    )