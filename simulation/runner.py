from ai_models.audio.audio_model import AudioAnomalyDetector
from ai_models.visual.visual_model import VisualAnomalyDetector
from ai_models.fusion.fusion_engine import FusionEngine
from ai_models.fusion.alert_logic import AlertLogic
from simulation.scenarios import (
    normal, gunshot, explosion, scream,
    glass_break,
    crying_distress, fight_sounds,
    siren, car_crash,
    intruder_detected, weapon_detected,
    visual_explosion, vehicle_intrusion,
    abuse, fighting, assault,
    robbery, person_down,
    forced_entry, suspicious_package,
)

ALL_SCENARIOS = [
    normal, gunshot, explosion, scream,
    glass_break,
    crying_distress, fight_sounds,
    siren, car_crash,
    intruder_detected, weapon_detected,
    visual_explosion, vehicle_intrusion,
    abuse, fighting, assault,
    robbery, person_down,
    forced_entry, suspicious_package,
]


def run_all():
    audio_model = AudioAnomalyDetector()
    visual_model = VisualAnomalyDetector()
    fusion = FusionEngine()
    alert_logic = AlertLogic()

    print("=" * 60)
    print("   RUNNING ALL SURVEILLANCE SCENARIOS")
    print("=" * 60)

    alerts_fired = 0
    high = 0
    medium = 0
    low = 0
    passed = 0
    failed = 0

    for scenario_module in ALL_SCENARIOS:
        scenario = scenario_module.simulate()
        name = scenario["name"]
        expected_severity = scenario.get("expected_severity", "any")

        # Run both real models
        audio_result = audio_model.predict(scenario["audio"], scenario["sr"])
        visual_result = visual_model.predict(scenario["visual"]["frame"])

        fusion_result = fusion.fuse(audio_result, visual_result)
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
            detail = (
                f"audio={audio_result['label']} "
                f"visual={visual_result['label']}"
            )

        # Pass/fail check against expected severity
        if expected_severity == "any" or severity == expected_severity:
            verdict = "✓ PASS"
            passed += 1
        else:
            verdict = f"✗ FAIL (expected {expected_severity}, got {severity})"
            failed += 1

        print(f"\n{name:<25} {status}")
        print(f"  Audio    : {audio_result['label']} ({audio_result['confidence']:.2f})")
        print(f"  Visual   : {visual_result['label']} ({visual_result['confidence']:.2f})")
        print(f"  Fused    : {fusion_result['fused_score']} → severity={severity}")
        print(f"  Verdict  : {verdict}")
        print(f"  Detail   : {detail}")

    print("\n" + "=" * 60)
    print(f"  Scenarios run : {len(ALL_SCENARIOS)}")
    print(f"  Alerts fired  : {alerts_fired}")
    print(f"  High          : {high}")
    print(f"  Medium        : {medium}")
    print(f"  Low           : {low}")
    print(f"  Passed        : {passed}")
    print(f"  Failed        : {failed}")
    print("=" * 60)


if __name__ == "__main__":
    run_all()