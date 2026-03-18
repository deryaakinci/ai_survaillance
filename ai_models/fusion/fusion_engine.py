class FusionEngine:
    def fuse(
        self,
        audio_result: dict,
        visual_result: dict,
    ) -> dict:
        audio_label = audio_result.get("label", "normal")
        visual_label = visual_result.get("label", "normal")
        audio_conf = audio_result.get("confidence", 0.0)
        visual_conf = visual_result.get("confidence", 0.0)

        # Weighted fusion — audio slightly more weight for this system
        fused_score = (audio_conf * 0.55) + (visual_conf * 0.45)

        # Get severity from both
        severity = self._get_severity(audio_label, visual_label)

        # Alert fires only if both agree something is wrong
        audio_normal = audio_label == "normal"
        visual_normal = visual_label == "normal"

        if audio_normal and visual_normal:
            alert = False
        elif audio_normal or visual_normal:
            # Only one detected something — alert only if high confidence
            alert = fused_score > 0.75
        else:
            # Both detected something — lower threshold
            alert = fused_score > 0.55

        return {
            "alert": alert,
            "severity": severity,
            "fused_score": round(fused_score, 3),
            "audio_label": audio_label,
            "visual_label": visual_label,
            "zone": "Zone 1",
        }

    def _get_severity(
        self,
        audio_label: str,
        visual_label: str,
    ) -> str:
        high_audio = [
            "gunshot",
            "explosion",
            "scream",
            "fight_sounds",
            "door_forced",
            "threatening_voice",
        ]
        high_visual = [
            "weapon_detected",
            "person_down",
            "multiple_intruders",
            "masked_person",
            "forced_entry",
        ]
        medium_audio = [
            "glass_break",
            "break_in",
            "crying_distress",
            "alarm_triggered",
            "car_crash",
        ]
        medium_visual = [
            "intruder_detected",
            "crowd_detected",
            "vehicle_intrusion",
            "fighting",
            "suspicious_package",
        ]

        if audio_label in high_audio or visual_label in high_visual:
            return "high"
        elif audio_label in medium_audio or visual_label in medium_visual:
            return "medium"
        return "low"