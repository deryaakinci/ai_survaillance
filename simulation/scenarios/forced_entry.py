from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Forced entry",
        audio_label="forced_entry",
        visual_label="intrusion_detected",
        expected_severity="high",
    )