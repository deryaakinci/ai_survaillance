from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from backend.database.db import get_db
from backend.database.models import Event

router = APIRouter()

@router.get("/")
def get_events(db: Session = Depends(get_db)):
    events = db.query(Event).order_by(Event.timestamp.desc()).limit(50).all()
    return events

@router.post("/")
def create_event(audio_label: str, visual_label: str, fusion_score: float, db: Session = Depends(get_db)):
    event = Event(
        audio_label=audio_label,
        visual_label=visual_label,
        fusion_score=fusion_score,
        alert_fired=fusion_score > 0.65
    )
    db.add(event)
    db.commit()
    db.refresh(event)
    return event