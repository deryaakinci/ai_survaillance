from datetime import datetime


class AlertLogic:
    def __init__(self):
        self.alert_history = []

    CRITICAL_LABELS = [
        "gunshot",
        "explosion",
        "weapon_detected",
        "person_down",
        "scream",
    ]

    def should_send_alert(self, fusion_result: dict) -> bool:
        if not fusion_result.get("alert"):
            return False

        now = datetime.utcnow()

        audio_label = fusion_result.get("audio_label")
        visual_label = fusion_result.get("visual_label")

        is_critical = (
            audio_label in self.CRITICAL_LABELS
            or visual_label in self.CRITICAL_LABELS
        )

        # Critical events always bypass the duplicate check
        if not is_critical:
            recent_duplicates = [
                a for a in self.alert_history
                if (now - a["timestamp"]).total_seconds() < 30
                and a["audio_label"] == audio_label
                and a["visual_label"] == visual_label
            ]
            if recent_duplicates:
                return False

        self.alert_history.append({
            "timestamp": now,
            "audio_label": audio_label,
            "visual_label": visual_label,
        })

        # Clean history older than 5 minutes (fixed: was .seconds, now .total_seconds)
        self.alert_history = [
            a for a in self.alert_history
            if (now - a["timestamp"]).total_seconds() < 300
        ]

        return True

    def build_alert_payload(self, fusion_result: dict) -> dict:
        severity = fusion_result.get("severity", "low")
        audio_label = fusion_result.get("audio_label")
        visual_label = fusion_result.get("visual_label")
        zone = fusion_result.get("zone", "Zone 1")

        return {
            "audio_label": audio_label,
            "visual_label": visual_label,
            "severity": severity,
            "zone": zone,
            "timestamp": datetime.utcnow().isoformat(),
            "alert": fusion_result.get("alert"),
            "title": self._get_notification_title(audio_label, severity),
            "body": self._get_notification_body(audio_label, visual_label, zone),
        }

    def _get_notification_title(self, audio_label: str, severity: str) -> str:
        titles = {
            "gunshot": "Gunshot detected",
            "explosion": "Explosion detected",
            "scream": "Scream detected",
            "glass_break": "Glass break detected",
            "break_in": "Break-in attempt detected",
            "door_forced": "Door being forced",
            "crying_distress": "Distress detected",
            "fight_sounds": "Fight detected",
            "alarm_triggered": "Alarm triggered",
            "siren": "Emergency siren nearby",
            "car_crash": "Car crash detected",
            "threatening_voice": "Threatening voice detected",
        }
        prefix = "🚨" if severity == "high" else "⚠️"
        return f"{prefix} {titles.get(audio_label, 'Alert detected')}"

    def _get_notification_body(
        self, audio_label: str, visual_label: str, zone: str
    ) -> str:
        return (
            f"Audio: {audio_label.replace('_', ' ').title()} · "
            f"Visual: {visual_label.replace('_', ' ').title()} · "
            f"{zone}"
        )