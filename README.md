# AI Surveillance System

An intelligent audio-visual fusion surveillance platform that detects security threats in real time by combining deep learning on audio and video streams. Alerts are delivered instantly to a cross-platform Flutter mobile app via WebSockets.

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────┐
│                       Simulation / Camera                     │
│          (video frames  +  audio chunks)                      │
└────────────────────┬─────────────────────────────────────────┘
                     │
          ┌──────────▼───────────┐
          │     AI Models Layer  │
          │  ┌────────────────┐  │
          │  │  AudioCNN      │  │ 
               11 classes
          │  │  (PyTorch)     │  │
          │  └───────┬────────┘  │
          │  ┌───────▼────────┐  │
          │  │  VisualDetector│  │  ← ResNet18 + YOLOv8 scanner
          │  │  (ResNet18)    │  │
          │  └───────┬────────┘  │
          │  ┌───────▼────────┐  │
          │  │  FusionEngine  │  │  ← Cross-modal consistency
          │  └───────┬────────┘  │     + confidence scoring
          └──────────┼───────────┘
                     │
          ┌──────────▼───────────┐
          │   FastAPI Backend    │  ← REST + WebSocket
          │   PostgreSQL / ORM   │
          └──────────┬───────────┘
                     │ WebSocket / REST
          ┌──────────▼───────────┐
          │    Flutter Mobile    │  ← 
             IOS / Web / Desktop
          │    App               │
          └──────────────────────┘
```

---

## Features

### AI Models

| Layer | Model | Details |
|---|---|---|
| Audio | `AudioCNN` | 3-block Conv2D on Mel-spectrograms, 11 threat classes |
| Visual | `VisualAnomalyDetector` | ResNet18 scene classifier + YOLOv8n weapon scanner |
| Fusion | `FusionEngine` | Cross-modal consistency check, confidence thresholding, severity scoring |
| Object Tracking | `FusionEngine` | Abandoned-object detection (ownership registry + 60 s timer) |

**Audio threat classes:** `gunshot`, `explosion`, `scream`, `glass_break`, `forced_entry`, `crying_distress`, `fight_sounds`, `siren`, `car_crash`, `threatening_voice`

**Visual threat classes:** `intruder_detected`, `weapon_detected`, `explosion`, `vehicle_intrusion`, `abuse`, `fighting`, `assault`, `robbery`, `person_down`, `forced_entry`

**Severity levels:**

| Level | Example triggers |
|---|---|
| High | weapon detected, gunshot, explosion, assault, abuse, person down |
| Medium | intruder, vehicle intrusion, glass break, car crash |
| Low | siren, suspicious package |

### Fusion Logic

- **Confidence floor** — predictions below 0.25 are discarded as noise.
- **Cross-modal consistency** — if audio and visual labels are semantically incompatible (e.g. `gunshot` audio with `car_crash` visual), the audio prediction is overridden and its confidence is penalised 70%.
- **Agreement bonus** — when both modalities agree on the same label, the fused score is boosted 15%.
- **Disagreement penalty** — conflicting non-normal labels are averaged with an 85% multiplier.

### Backend

- **FastAPI** with async WebSocket connection manager (per-user channels).
- **SQLAlchemy + PostgreSQL** — `Event`, `Alert`, and `User` tables.
- **JWT authentication** — HMAC-SHA256 signed tokens with expiry.
- **Demo broadcast endpoint** — pushes simulation events to every registered user; deduplicates alerts per threat type per run.
- **Snapshot serving** — static endpoint for JPEG frame snapshots linked to alerts.

### Mobile App (Flutter)

| Screen | Description |
|---|---|
| Login | Secure auth with token stored in device secure storage |
| Dashboard | Live status, active alerts, camera feed overview |
| Alerts | Real-time alert list, severity badges, snapshot previews |
| Analytics | Charts (fl_chart) over historical event data |
| History | Full event log with confidence scores and fusion results |
| Account | User profile and notification settings |

Real-time updates are driven by a `WebSocketService` provider; the app also polls the REST API as a fallback.

---

## Project Structure

```
ai_survaillance/
├── ai_models/
│   ├── audio/
│   │   ├── audio_model.py          # AudioCNN + AudioAnomalyDetector
│   │   ├── train_audio_model.py    # Training script
│   │   └── saved_model/            # best_model.pth + labels.json
│   ├── visual/
│   │   ├── visual_model.py         # VisualAnomalyDetector (ResNet18 + YOLO)
│   │   ├── train_visual_classifier.py
│   │   └── saved_model/            # best_classifier.pth + YOLO weights
│   └── fusion/
│       ├── fusion_engine.py        # FusionEngine + abandoned-object tracker
│       └── alert_logic.py          # AlertLogic (threshold → fire/suppress)
├── backend/
│   ├── main.py                     # FastAPI app, WebSocket manager
│   ├── api/routes/
│   │   ├── events.py               # Event CRUD + demo_broadcast
│   │   ├── alerts.py               # Alert retrieval
│   │   ├── stats.py                # Aggregated analytics
│   │   └── auth.py                 # Register / login / token
│   ├── database/
│   │   ├── models.py               # Event, Alert, User ORM models
│   │   └── db.py                   # SQLAlchemy engine + session
│   └── services/
│       └── notifier.py             # NotificationService (WebSocket dispatch)
├── simulation/
│   ├── runner.py                   # Runs all 20+ scenarios end-to-end
│   ├── demo_video_runner.py        # Plays demo MP4s through the AI pipeline
│   ├── base.py                     # Scenario loader (audio + visual assets)
│   ├── scenarios/                  # One module per threat type
│   └── input_gen/                  # Synthetic audio / video generators
├── mobile_app/                     # Flutter project (iOS, Android, Web, Desktop)
├── evaluate_models.py              # Offline model evaluation script
├── seed_db.py                      # Database seed script
├── yolov8n.pt                      # YOLOv8n base weights
└── requirements.txt
```

---

## Setup

### Prerequisites

- Python 3.11+
- PostgreSQL
- Flutter SDK 3.x
- (Optional) Apple Silicon Mac for MPS GPU acceleration

### 1. Python Environment

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 2. Environment Variables

Create a `.env` file in the project root:

```env
DATABASE_URL=postgresql://user:password@localhost:5432/surveillance
SECRET_KEY=your_secret_key_here
```

### 3. Database

```bash
# Initialise tables (runs automatically on first API start)
python seed_db.py
```

### 4. Train the Models

```bash
# Audio model
python ai_models/audio/train_audio_model.py

# Visual classifier
python ai_models/visual/train_visual_classifier.py
```

Pre-trained weights are included in `ai_models/*/saved_model/` for immediate use.

### 5. Run the Backend

```bash
uvicorn backend.main:app --reload --host 0.0.0.0 --port 8000
```

API docs available at `http://localhost:8000/docs`.

### 6. Run the Simulation

```bash


# Stream demo video files through the full AI pipeline
python simulation/demo_video_runner.py
```

### 7. Mobile App

```bash
cd mobile_app
flutter pub get
flutter run
```

---

## API Reference

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/auth/register` | Create account |
| `POST` | `/auth/login` | Returns JWT token |
| `GET` | `/events/` | List events for authenticated user |
| `POST` | `/events/` | Store an AI-processed event |
| `POST` | `/events/demo_broadcast` | Broadcast simulation event to all users |
| `POST` | `/events/demo_broadcast/reset` | Clear deduplication state |
| `GET` | `/alerts/` | List alerts for authenticated user |
| `GET` | `/stats/` | Aggregated analytics |
| `WS` | `/ws/{user_id}` | Real-time alert channel |

---

## Tech Stack

| Layer | Technology |
|---|---|
| AI / ML | PyTorch, torchvision, Librosa, OpenCV, Ultralytics YOLOv8 |
| Backend | FastAPI, SQLAlchemy, PostgreSQL, Uvicorn |
| Mobile | Flutter, Dart, Provider, fl_chart, web_socket_channel |
| Hardware acceleration | Apple MPS (M-series) / CUDA |

---

## Simulation Scenarios

The runner exercises 20+ scenarios covering the full threat taxonomy:

`normal` · `gunshot` · `explosion` · `scream` · `glass_break` · `crying_distress` · `fight_sounds` · `siren` · `car_crash` · `threatening_voice` · `intruder_detected` · `weapon_detected` · `visual_explosion` · `vehicle_intrusion` · `abuse` · `fighting` · `assault` · `robbery` · `person_down` · `forced_entry` · `suspicious_package`

Each scenario loads matching audio and video samples from the dataset, runs them through both models, fuses the results, and validates the output severity against the expected value.
