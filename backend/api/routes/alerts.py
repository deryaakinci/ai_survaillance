from fastapi import APIRouter, Depends, Request, HTTPException
from sqlalchemy.orm import Session
from backend.database.db import get_db
from backend.database.models import Alert
from backend.services.notifier import NotificationService
from datetime import datetime, timedelta
import base64
import hashlib
import hmac
import json
import os
import uuid


router = APIRouter()

SECRET_KEY = os.getenv("SECRET_KEY", "your_secret_key_change_in_production")


def get_current_user_id(request: Request) -> str:
    """Extract and VERIFY user ID from JWT token"""
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")

    token = auth_header.split(" ")[1]

    try:
        parts = token.split(".")
        if len(parts) != 2:
            raise HTTPException(status_code=401, detail="Invalid token format")

        payload_b64, provided_signature = parts[0], parts[1]

        # --- Verify signature ---
        expected_signature = hmac.new(
            SECRET_KEY.encode(),
            payload_b64.encode(),
            hashlib.sha256,
        ).hexdigest()

        if not hmac.compare_digest(expected_signature, provided_signature):
            raise HTTPException(status_code=401, detail="Invalid token signature")

        # --- Decode payload ---
        payload = json.loads(base64.b64decode(payload_b64 + "=="))

        # --- Check expiry ---
        import time
        if payload.get("exp", 0) < int(time.time()):
            raise HTTPException(status_code=401, detail="Token expired")

        user_id = payload.get("user_id")
        if not user_id:
            raise HTTPException(status_code=401, detail="Token missing user_id")

        return user_id

    except HTTPException:
        raise
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token")


@router.get("/")
def get_alerts(
    days: int = 7,
    request: Request = None,
    db: Session = Depends(get_db),
):
    user_id = get_current_user_id(request)
    since = datetime.utcnow() - timedelta(days=days)

    alerts = (
        db.query(Alert)
        .filter(
            Alert.user_id == user_id,
            Alert.timestamp >= since,
        )
        .order_by(Alert.timestamp.desc())
        .all()
    )

    return [
        {
            "id": a.id,
            "audio_label": a.audio_label,
            "visual_label": a.visual_label,
            "severity": a.severity,
            "zone": a.zone,
            "timestamp": a.timestamp.isoformat(),
            "snapshot_url": a.snapshot_url,
            "audio_clip_url": a.audio_clip_url,
        }
        for a in alerts
    ]


@router.post("/")
async def create_alert(
    audio_label: str,
    visual_label: str,
    severity: str,
    zone: str = "Zone 1",
    request: Request = None,
    db: Session = Depends(get_db),
):
    # Get user_id from token — not from query param
    user_id = get_current_user_id(request)

    alert = Alert(
        id=str(uuid.uuid4()),
        user_id=user_id,
        audio_label=audio_label,
        visual_label=visual_label,
        severity=severity,
        zone=zone,
        timestamp=datetime.utcnow(),
    )
    db.add(alert)
    db.commit()
    db.refresh(alert)

    if request and hasattr(request.app.state, "manager"):
        notifier = NotificationService(request.app.state.manager)
        await notifier.send_alert(user_id, {
            "id": alert.id,
            "audio_label": audio_label,
            "visual_label": visual_label,
            "severity": severity,
            "zone": zone,
            "timestamp": alert.timestamp.isoformat(),
            "title": _get_title(audio_label, severity),
            "body": f"{audio_label} · {visual_label} · {zone}",
        })

    return alert


@router.get("/stats")
def get_stats(
    days: int = 7,
    request: Request = None,
    db: Session = Depends(get_db),
):
    user_id = get_current_user_id(request)
    since = datetime.utcnow() - timedelta(days=days)

    total = db.query(Alert).filter(
        Alert.user_id == user_id,
        Alert.timestamp >= since,
    ).count()

    high = db.query(Alert).filter(
        Alert.user_id == user_id,
        Alert.timestamp >= since,
        Alert.severity == "high",
    ).count()

    medium = db.query(Alert).filter(
        Alert.user_id == user_id,
        Alert.timestamp >= since,
        Alert.severity == "medium",
    ).count()

    low = db.query(Alert).filter(
        Alert.user_id == user_id,
        Alert.timestamp >= since,
        Alert.severity == "low",
    ).count()

    return {
        "total": total,
        "high": high,
        "medium": medium,
        "low": low,
        "days": days,
        "accuracy": 98,
    }


def _get_title(audio_label: str, severity: str) -> str:
    titles = {
        "gunshot": "Gunshot detected",
        "explosion": "Explosion detected",
        "scream": "Scream detected",
        "glass_break": "Glass break detected",
        "forced_entry": "Forced entry detected",
        "crying_distress": "Distress detected",
        "fight_sounds": "Fight detected",
        "siren": "Emergency siren nearby",
        "car_crash": "Car crash detected",
        "threatening_voice": "Threatening voice",
    }
    prefix = "🚨" if severity == "high" else "⚠️"
    return f"{prefix} {titles.get(audio_label, 'Alert detected')}"