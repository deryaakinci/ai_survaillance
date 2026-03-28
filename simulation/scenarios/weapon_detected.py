from simulation.scenarios.base import load_scenario

def simulate() -> dict:
    return load_scenario(
        name="Weapon detected",
        audio_label="gunshot",
        visual_label="weapon_detected",
        expected_severity="high",
    )