import os
import sys
import uuid
import random
from datetime import datetime, timedelta

# Ensure the backend module can be imported
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), ".")))

from backend.database.db import SessionLocal, init_db
from backend.database.models import User, Alert, Event

def seed_data():
    print("Initialising database tables (if they don't exist)...")
    init_db()

    db = SessionLocal()
    try:
        # Fetch all existing users
        users = db.query(User).all()
        
        user_ids = []
        if not users:
            # Create a dummy user if none exists
            dummy_user_id = str(uuid.uuid4())
            print(f"No users found. Creating Dummy User with ID: {dummy_user_id}")
            user = User(
                id=dummy_user_id,
                name="Test User",
                email="test@example.com",
                password_hash="fake_hash_value_for_testing"
            )
            db.add(user)
            db.commit()
            user_ids.append(dummy_user_id)
        else:
            print(f"Found {len(users)} existing users.")
            user_ids = [u.id for u in users]

        # 2. Add Dummy Alerts for each user
        print("Adding dummy alerts for users...")
        alert_types = [
            ("gunshot", "flash", "high"),
            ("scream", "running_person", "high"),
            ("glass_break", "broken_window", "medium"),
            ("car_crash", "smoke", "high"),
            ("fight_sounds", "two_people_fighting", "medium"),
            ("crying_distress", "sad_person", "low"),
        ]
        
        zones = ["Front Door", "Backyard", "Garage", "Living Room"]
        
        for uid in user_ids:
            print(f"Generating 20 alerts for user {uid}...")
            # Populate alerts over the last 7 days
            for i in range(20):
                audio, visual, severity = random.choice(alert_types)
                random_days_ago = random.randint(0, 6)
                random_hours_ago = random.randint(0, 23)
                random_minutes_ago = random.randint(0, 59)
                
                timestamp = datetime.utcnow() - timedelta(
                    days=random_days_ago, 
                    hours=random_hours_ago, 
                    minutes=random_minutes_ago
                )

                alert = Alert(
                    id=str(uuid.uuid4()),
                    user_id=uid,
                    audio_label=audio,
                    visual_label=visual,
                    severity=severity,
                    zone=random.choice(zones),
                    timestamp=timestamp
                )
                db.add(alert)
        
        db.commit()
        print("\n--- Seed Completed Successfully! ---")
        print("You can see these alerts on the app for any currently registered user.")

    finally:
        db.close()

if __name__ == "__main__":
    seed_data()
