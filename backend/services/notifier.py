from datetime import datetime


class SystemHealthMonitor:
    def __init__(self):
        self.audio_status = True
        self.visual_status = True
        self.last_audio_signal = datetime.utcnow()
        self.last_visual_signal = datetime.utcnow()

    def update_audio(self, success: bool):
        self.audio_status = success
        if success:
            self.last_audio_signal = datetime.utcnow()

    def update_visual(self, success: bool):
        self.visual_status = success
        if success:
            self.last_visual_signal = datetime.utcnow()

    def get_status(self) -> dict:
        now = datetime.utcnow()
        audio_age = (now - self.last_audio_signal).seconds
        visual_age = (now - self.last_visual_signal).seconds

        return {
            "audio_online": self.audio_status and audio_age < 30,
            "visual_online": self.visual_status and visual_age < 30,
            "overall": self._overall_status(audio_age, visual_age),
            "reliability": self._estimate_reliability(),
        }

    def _overall_status(self, audio_age: int, visual_age: int) -> str:
        if audio_age < 30 and visual_age < 30:
            return "fully operational"
        elif audio_age < 30 or visual_age < 30:
            return "degraded — one sensor offline"
        return "critical — all sensors offline"

    def _estimate_reliability(self) -> str:
        if self.audio_status and self.visual_status:
            return "91%"
        elif self.audio_status or self.visual_status:
            return "~70%"
        return "0%"


class NotificationService:
    def __init__(self, manager=None):
        self.manager = manager

    async def send_alert(self, user_id: str, payload: dict):
        """Send alert only to the user who owns this alert"""
        if self.manager:
            await self.manager.send_to_user(user_id, {
                "type": "alert",
                "data": payload,
            })
            print(f"Alert sent to user {user_id}: {payload.get('title')}")

    async def send_sensor_status(self, user_id: str, status: dict):
        """Send sensor status only to the relevant user"""
        if self.manager:
            await self.manager.send_to_user(user_id, {
                "type": "sensor_status",
                "data": status,
            })