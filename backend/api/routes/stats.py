from fastapi import APIRouter, Depends, Request, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func, extract
from backend.database.db import get_db
from backend.database.models import Alert
from datetime import datetime, timedelta
import base64
import hashlib
import hmac
import json
import os

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

        expected_signature = hmac.new(
            SECRET_KEY.encode(),
            payload_b64.encode(),
            hashlib.sha256,
        ).hexdigest()

        if not hmac.compare_digest(expected_signature, provided_signature):
            raise HTTPException(status_code=401, detail="Invalid token signature")

        payload = json.loads(base64.b64decode(payload_b64 + "=="))

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
def get_stats_overview(
    days: int = 7,
    request: Request = None,
    db: Session = Depends(get_db),
):
    """Return full analytics: totals, today count, accuracy, type breakdown, hourly heatmap."""
    user_id = get_current_user_id(request)
    since = datetime.utcnow() - timedelta(days=days)

    # ── Total alerts in timeframe ──────────────────────────────────────
    total = db.query(Alert).filter(
        Alert.user_id == user_id,
        Alert.timestamp >= since,
    ).count()

    # ── Alerts today ──────────────────────────────────────────────────
    today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
    alerts_today = db.query(Alert).filter(
        Alert.user_id == user_id,
        Alert.timestamp >= today_start,
    ).count()

    # ── Severity breakdown ────────────────────────────────────────────
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

    # ── Alert type breakdown (by audio_label) ─────────────────────────
    type_keys = [
        "gunshot", "explosion", "scream", "break_in",
        "glass_break", "fight", "door_forced", "weapon",
        "crying_distress", "siren", "car_crash", "threatening_voice",
    ]

    alert_types = {}
    for key in type_keys:
        count = db.query(Alert).filter(
            Alert.user_id == user_id,
            Alert.timestamp >= since,
            Alert.audio_label.ilike(f"%{key}%"),
        ).count()
        alert_types[key] = count

    # ── Most active hours (24-element list, index = hour of day) ──────
    hourly_rows = (
        db.query(
            extract("hour", Alert.timestamp).label("hour"),
            func.count().label("cnt"),
        )
        .filter(
            Alert.user_id == user_id,
            Alert.timestamp >= since,
        )
        .group_by("hour")
        .all()
    )

    hourly = [0] * 24
    for row in hourly_rows:
        h = int(row.hour)
        if 0 <= h < 24:
            hourly[h] = row.cnt

    # ── Accuracy (from real AI data) ────────────────────────────────
    # Computed as the average fusion_score across all events the AI
    # processed in this timeframe, expressed as a percentage.
    # Also returns per-model confidence averages.
    from backend.database.models import Event

    total_events = db.query(Event).filter(
        Event.user_id == user_id,
        Event.timestamp >= since,
    ).count()

    accuracy = None
    audio_accuracy = None
    visual_accuracy = None

    if total_events > 0:
        avg_fusion = db.query(func.avg(Event.fusion_score)).filter(
            Event.user_id == user_id,
            Event.timestamp >= since,
            Event.fusion_score.isnot(None),
        ).scalar()

        avg_audio = db.query(func.avg(Event.audio_confidence)).filter(
            Event.user_id == user_id,
            Event.timestamp >= since,
            Event.audio_confidence.isnot(None),
        ).scalar()

        avg_visual = db.query(func.avg(Event.visual_confidence)).filter(
            Event.user_id == user_id,
            Event.timestamp >= since,
            Event.visual_confidence.isnot(None),
        ).scalar()

        if avg_fusion is not None:
            accuracy = round(float(avg_fusion) * 100, 1)
        if avg_audio is not None:
            audio_accuracy = round(float(avg_audio) * 100, 1)
        if avg_visual is not None:
            visual_accuracy = round(float(avg_visual) * 100, 1)

    return {
        "total": total,
        "today": alerts_today,
        "accuracy": accuracy,
        "audio_accuracy": audio_accuracy,
        "visual_accuracy": visual_accuracy,
        "total_events": total_events,
        "high": high,
        "medium": medium,
        "low": low,
        "days": days,
        "alert_types": alert_types,
        "hourly": hourly,
    }

