from sqlalchemy import Column, String, Float, DateTime, Boolean
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
import uuid

Base = declarative_base()


class Event(Base):
    __tablename__ = "events"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, nullable=False)
    timestamp = Column(DateTime, default=datetime.utcnow)
    audio_label = Column(String)
    visual_label = Column(String)
    fusion_score = Column(Float)
    alert_fired = Column(Boolean, default=False)
    zone = Column(String, default="Zone 1")


class Alert(Base):
    __tablename__ = "alerts"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, nullable=False)
    event_id = Column(String, nullable=True)
    audio_label = Column(String)
    visual_label = Column(String)
    severity = Column(String, default="low")
    zone = Column(String, default="Zone 1")
    snapshot_url = Column(String, nullable=True)
    audio_clip_url = Column(String, nullable=True)
    timestamp = Column(DateTime, default=datetime.utcnow)


class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String)
    email = Column(String, unique=True)
    password_hash = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)