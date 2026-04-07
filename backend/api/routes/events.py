from fastapi import APIRouter, Depends, Request, HTTPException
from sqlalchemy.orm import Session
from backend.database.db import get_db
from backend.database.models import Event
from datetime import datetime
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
def list_events(
    days: int = 7,
    request: Request = None,
    db: Session = Depends(get_db),
):
    """List all AI-processed events for the authenticated user."""
    user_id = get_current_user_id(request)
    from datetime import timedelta
    since = datetime.utcnow() - timedelta(days=days)

    events = (
        db.query(Event)
        .filter(
            Event.user_id == user_id,
            Event.timestamp >= since,
        )
        .order_by(Event.timestamp.desc())
        .limit(200)
        .all()
    )

    return [
        {
            "id": e.id,
            "audio_label": e.audio_label,
            "visual_label": e.visual_label,
            "audio_confidence": e.audio_confidence,
            "visual_confidence": e.visual_confidence,
            "fusion_score": e.fusion_score,
            "alert_fired": e.alert_fired,
            "zone": e.zone,
            "timestamp": e.timestamp.isoformat() if e.timestamp else None,
        }
        for e in events
    ]


@router.post("/")
def create_event(
    request: Request,
    db: Session = Depends(get_db),
    audio_label: str = "normal",
    visual_label: str = "normal",
    audio_confidence: float = 0.0,
    visual_confidence: float = 0.0,
    fusion_score: float = 0.0,
    alert_fired: bool = False,
    zone: str = "Zone 1",
):
    """
    Store an AI-processed event.
    Called by the simulation / AI pipeline after each analysis chunk.
    """
    user_id = get_current_user_id(request)

    event = Event(
        id=str(uuid.uuid4()),
        user_id=user_id,
        audio_label=audio_label,
        visual_label=visual_label,
        audio_confidence=audio_confidence,
        visual_confidence=visual_confidence,
        fusion_score=fusion_score,
        alert_fired=alert_fired,
        zone=zone,
        timestamp=datetime.utcnow(),
    )
    db.add(event)
    db.commit()
    db.refresh(event)

    return {
        "id": event.id,
        "fusion_score": event.fusion_score,
        "alert_fired": event.alert_fired,
    }


@router.post("/demo_broadcast")
async def demo_broadcast_event(
    request: Request,
    db: Session = Depends(get_db),
    audio_label: str = "normal",
    visual_label: str = "normal",
    audio_confidence: float = 0.0,
    visual_confidence: float = 0.0,
    fusion_score: float = 0.0,
    alert_fired: bool = False,
    severity: str = "low",
    zone: str = "Demo Camera",
):
    """
    Broadcasts a simulation event to ALL users in the database automatically.
    This allows the simulation script to trigger live alerts on any user's dashboard.
    """
    from backend.database.models import User, Alert
    from backend.services.notifier import NotificationService
    from backend.api.routes.alerts import _get_title
    
    users = db.query(User).all()
    
    for user in users:
        # Create event for user
        event = Event(
            id=str(uuid.uuid4()),
            user_id=user.id,
            audio_label=audio_label,
            visual_label=visual_label,
            audio_confidence=audio_confidence,
            visual_confidence=visual_confidence,
            fusion_score=fusion_score,
            alert_fired=alert_fired,
            zone=zone,
            timestamp=datetime.utcnow(),
        )
        db.add(event)
        
        # Create alert if fired
        if alert_fired:
            alert = Alert(
                id=str(uuid.uuid4()),
                user_id=user.id,
                audio_label=audio_label,
                visual_label=visual_label,
                severity=severity,
                zone=zone,
                timestamp=datetime.utcnow(),
            )
            db.add(alert)
            
            # Send real-time websocket alert
            if hasattr(request.app.state, "manager"):
                notifier = NotificationService(request.app.state.manager)
                await notifier.send_alert(user.id, {
                    "id": alert.id,
                    "audio_label": audio_label,
                    "visual_label": visual_label,
                    "severity": severity,
                    "zone": zone,
                    "timestamp": alert.timestamp.isoformat(),
                    "title": _get_title(audio_label, severity),
                    "body": f"{audio_label.replace('_', ' ').title()} · {visual_label.replace('_', ' ').title()} · {zone}",
                })
                
    db.commit()
    return {"status": "broadcast_successful", "users_reached": len(users)}

