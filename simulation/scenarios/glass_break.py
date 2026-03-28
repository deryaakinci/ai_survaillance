from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Glass break",
        audio_label="glass_break",
        visual_label="intruder_detected",
        expected_severity="medium",
    )