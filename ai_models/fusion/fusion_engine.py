CRITICAL_AUDIO = [
    "gunshot",
    "explosion",
    "scream",
    "fight_sounds",
    "door_forced",
    "threatening_voice",
]

CRITICAL_VISUAL = [
    "weapon_detected",
    "person_down",
    "forced_entry",
]

HIGH_AUDIO = CRITICAL_AUDIO  # same set

HIGH_VISUAL = CRITICAL_VISUAL + [
    "multiple_intruders",
    "masked_person",
]

MEDIUM_AUDIO = [
    "glass_break",
    "break_in",
    "crying_distress",
    "alarm_triggered",
    "car_crash",
]

MEDIUM_VISUAL = [
    "intruder_detected",
    "crowd_detected",
    "vehicle_intrusion",
    "fighting",
    "suspicious_package",
]


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

        audio_normal = audio_label == "normal"
        visual_normal = visual_label == "normal"

        # Short-circuit — both normal, nothing to do
        if audio_normal and visual_normal:
            return {
                "alert": False,
                "severity": "low",
                "fused_score": 0.0,
                "audio_label": "normal",
                "visual_label": "normal",
                "zone": "Zone 1",
            }

        # Normal detections contribute 0.0 — not their "normal" confidence
        audio_score = 0.0 if audio_normal else audio_conf
        visual_score = 0.0 if visual_normal else visual_conf

        # Weighted fusion
        fused_score = (audio_score * 0.55) + (visual_score * 0.45)

        # Critical labels always fire immediately regardless of fused score
        is_critical = (
            audio_label in CRITICAL_AUDIO
            or visual_label in CRITICAL_VISUAL
        )

        if is_critical:
            alert = True
        elif audio_normal or visual_normal:
            # Only one sensor detected something — needs high confidence
            alert = fused_score > 0.75
        else:
            # Both sensors detected something — lower threshold
            alert = fused_score > 0.55

        severity = self._get_severity(
            audio_label, visual_label, audio_normal, visual_normal
        )

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
        audio_normal: bool,
        visual_normal: bool,
    ) -> str:
        audio_high = audio_label in HIGH_AUDIO
        visual_high = visual_label in HIGH_VISUAL
        audio_medium = audio_label in MEDIUM_AUDIO
        visual_medium = visual_label in MEDIUM_VISUAL

        # Either sensor flags high → high
        if audio_high or visual_high:
            return "high"

        # Both sensors independently flag medium → escalate to high
        if audio_medium and visual_medium:
            return "high"

        # One sensor flags medium, other is not normal → medium
        if audio_medium or visual_medium:
            return "medium"

        # Both detected something but neither is in defined lists
        if not audio_normal and not visual_normal:
            return "medium"

        return "low"