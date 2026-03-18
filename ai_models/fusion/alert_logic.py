from datetime import datetime


class AlertLogic:
    def __init__(self):
        self.alert_history = []

    def should_send_alert(self, fusion_result: dict) -> bool:
        if not fusion_result.get("alert"):
            return False

        now = datetime.utcnow()

        # Prevent duplicate alerts for same event within 30 seconds
        recent_duplicates = [
            a for a in self.alert_history
            if (now - a["timestamp"]).seconds < 30
            and a["audio_label"] == fusion_result["audio_label"]
            and a["visual_label"] == fusion_result["visual_label"]
        ]

        if recent_duplicates:
            return False

        # Always alert immediately for critical events
        critical = [
            "gunshot",
            "explosion",
            "weapon_detected",
            "person_down",
            "scream",
        ]
        is_critical = (
            fusion_result.get("audio_label") in critical
            or fusion_result.get("visual_label") in critical
        )

        self.alert_history.append({
            "timestamp": now,
            "audio_label": fusion_result.get("audio_label"),
            "visual_label": fusion_result.get("visual_label"),
        })

        # Clean old history older than 5 minutes
        self.alert_history = [
            a for a in self.alert_history
            if (now - a["timestamp"]).seconds < 300
        ]

        return True

    def build_alert_payload(self, fusion_result: dict) -> dict:
        severity = fusion_result.get("severity", "low")

        return {
            "audio_label": fusion_result.get("audio_label"),
            "visual_label": fusion_result.get("visual_label"),
            "severity": severity,
            "zone": fusion_result.get("zone", "Zone 1"),
            "timestamp": datetime.utcnow().isoformat(),
            "alert": fusion_result.get("alert"),
            "title": self._get_notification_title(
                fusion_result.get("audio_label"),
                severity,
            ),
            "body": self._get_notification_body(
                fusion_result.get("audio_label"),
                fusion_result.get("visual_label"),
                fusion_result.get("zone", "Zone 1"),
            ),
        }

    def _get_notification_title(
        self,
        audio_label: str,
        severity: str,
    ) -> str:
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
        self,
        audio_label: str,
        visual_label: str,
        zone: str,
    ) -> str:
        return (
            f"Audio: {audio_label.replace('_', ' ').title()} · "
            f"Visual: {visual_label.replace('_', ' ').title()} · "
            f"{zone}"
        )