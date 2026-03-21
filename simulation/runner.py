from ai_models.audio.audio_model import AudioAnomalyDetector
from ai_models.fusion.fusion_engine import FusionEngine
from ai_models.fusion.alert_logic import AlertLogic
from simulation.scenarios import (
    normal, gunshot, explosion, scream,
    glass_break, break_in, door_forced,
    crying_distress, fight_sounds, alarm_triggered,
    siren, car_crash, threatening_voice,
    intruder_detected, weapon_detected,
    multiple_intruders, vehicle_intrusion,
    loitering, fighting, crowd_detected,
    masked_person, person_down,
    forced_entry, suspicious_package,
)

ALL_SCENARIOS = [
    normal, gunshot, explosion, scream,
    glass_break, break_in, door_forced,
    crying_distress, fight_sounds, alarm_triggered,
    siren, car_crash, threatening_voice,
    intruder_detected, weapon_detected,
    multiple_intruders, vehicle_intrusion,
    loitering, fighting, crowd_detected,
    masked_person, person_down,
    forced_entry, suspicious_package,
]


def run_all():
    audio_model = AudioAnomalyDetector()
    fusion = FusionEngine()
    alert_logic = AlertLogic()

    print("=" * 55)
    print("   RUNNING ALL SURVEILLANCE SCENARIOS")
    print("=" * 55)

    alerts_fired = 0
    high = 0
    medium = 0
    low = 0

    for scenario_module in ALL_SCENARIOS:
        scenario = scenario_module.simulate()
        name = scenario["name"]

        audio_result = audio_model.predict(
            scenario["audio"],
            scenario["sr"],
        )
        fusion_result = fusion.fuse(
            audio_result,
            scenario["visual"],
        )

        alert_fired = alert_logic.should_send_alert(fusion_result)
        severity = fusion_result["severity"]

        if alert_fired:
            alerts_fired += 1
            if severity == "high":
                high += 1
            elif severity == "medium":
                medium += 1
            else:
                low += 1
            payload = alert_logic.build_alert_payload(fusion_result)
            status = "🚨 ALERT"
            detail = payload["title"]
        else:
            status = "✓  clear"
            detail = f"audio={audio_result['label']}"

        print(f"\n{name:<25} {status}")
        print(f"  Severity : {severity}")
        print(f"  Detail   : {detail}")

    print("\n" + "=" * 55)
    print(f"  Scenarios run : {len(ALL_SCENARIOS)}")
    print(f"  Alerts fired  : {alerts_fired}")
    print(f"  High          : {high}")
    print(f"  Medium        : {medium}")
    print(f"  Low           : {low}")
    print("=" * 55)


if __name__ == "__main__":
    run_all()