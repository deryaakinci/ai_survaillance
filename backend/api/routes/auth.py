from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from pydantic import BaseModel
from backend.database.db import get_db
from backend.database.models import User
import bcrypt
import hmac
import hashlib
import base64
import json
import time
import uuid
import os

router = APIRouter()

SECRET_KEY = os.getenv("SECRET_KEY", "your_secret_key_change_in_production")


class LoginRequest(BaseModel):
    email: str
    password: str


class SignupRequest(BaseModel):
    name: str
    email: str
    password: str


def create_token(user_id: str, email: str) -> str:
    payload = {
        "user_id": user_id,
        "email": email,
        "exp": int(time.time()) + 86400,
    }
    payload_b64 = base64.b64encode(
        json.dumps(payload).encode()
    ).decode()
    signature = hmac.new(
        SECRET_KEY.encode(),
        payload_b64.encode(),
        hashlib.sha256,
    ).hexdigest()
    return f"{payload_b64}.{signature}"


def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()


def verify_password(password: str, password_hash: str) -> bool:
    return bcrypt.checkpw(password.encode(), password_hash.encode())


@router.post("/login")
def login(request: LoginRequest, db: Session = Depends(get_db)):
    if not request.email or len(request.password) < 6:
        raise HTTPException(
            status_code=400,
            detail="Invalid email or password",
        )

    # Find user in database
    user = db.query(User).filter(
        User.email == request.email
    ).first()

    if not user:
        raise HTTPException(
            status_code=401,
            detail="Email not found",
        )

    # Check password
    if not verify_password(request.password, user.password_hash):
        raise HTTPException(
            status_code=401,
            detail="Incorrect password",
        )

    token = create_token(user.id, user.email)

    return {
        "id": user.id,
        "name": user.name,
        "email": user.email,
        "token": token,
    }


@router.post("/signup")
def signup(request: SignupRequest, db: Session = Depends(get_db)):
    if not request.name or not request.email or len(request.password) < 6:
        raise HTTPException(
            status_code=400,
            detail="Please fill all fields correctly",
        )

    # Check if email already exists
    existing = db.query(User).filter(
        User.email == request.email
    ).first()

    if existing:
        raise HTTPException(
            status_code=400,
            detail="Email already registered",
        )

    # Create new user
    user = User(
        id=str(uuid.uuid4()),
        name=request.name,
        email=request.email,
        password_hash=hash_password(request.password),
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    token = create_token(user.id, user.email)

    return {
        "id": user.id,
        "name": user.name,
        "email": user.email,
        "token": token,
    }