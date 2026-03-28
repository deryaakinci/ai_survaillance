from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Crying distress",
        audio_label="crying_distress",
        visual_label="intruder_detected",
        expected_severity="medium",
    )