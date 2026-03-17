from sqlalchemy import Column, String, Float, DateTime, Boolean
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
import uuid

Base = declarative_base()

class Event(Base):
    __tablename__ = "events"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    timestamp = Column(DateTime, default=datetime.utcnow)
    audio_label = Column(String)
    visual_label = Column(String)
    fusion_score = Column(Float)
    alert_fired = Column(Boolean, default=False)

class Alert(Base):
    __tablename__ = "alerts"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    event_id = Column(String)
    snapshot_url = Column(String, nullable=True)
    audio_clip_url = Column(String, nullable=True)
    timestamp = Column(DateTime, default=datetime.utcnow)