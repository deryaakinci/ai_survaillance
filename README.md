# AI Surveillance System

An intelligent audio-visual fusion surveillance platform that detects security threats in real time by combining deep learning on audio and video streams. Alerts are delivered instantly to a cross-platform Flutter mobile app via WebSockets.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Features](#features)
3. [Project Structure](#project-structure)
4. [Tech Stack](#tech-stack)
5. [Setup Guide](#setup-guide)
6. [User Guide](#user-guide)
7. [API Reference](#api-reference)
8. [Simulation Scenarios](#simulation-scenarios)

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────┐
│                   Simulation / Camera Input                   │
│            (demo MP4 files  +  synthetic audio)               │
└────────────────────┬─────────────────────────────────────────┘
                     │
          ┌──────────▼───────────┐
          │    AI Models Layer   │
          │  ┌────────────────┐  │
          │  │   AudioCNN     │  │  ← 11 threat classes
          │  │   (PyTorch)    │  │    Mel-spectrogram CNN
          │  └───────┬────────┘  │
          │  ┌───────▼────────┐  │
          │  │VisualDetector  │  │  ← ResNet18 scene classifier
          │  │ (ResNet18 +    │  │    + YOLOv8n weapon scanner
          │  │  YOLOv8n)      │  │
          │  └───────┬────────┘  │
          │  ┌───────▼────────┐  │
          │  │ FusionEngine   │  │  ← Cross-modal consistency
          │  └───────┬────────┘  │     + confidence scoring
          └──────────┼───────────┘     + abandoned-object tracker
                     │
          ┌──────────▼───────────┐
          │   FastAPI Backend    │  ← REST + WebSocket
          │   PostgreSQL / ORM   │    JWT authentication
          │   Static snapshots   │
          └──────────┬───────────┘
                     │ WebSocket / REST
          ┌──────────▼───────────┐
          │    Flutter Mobile    │  ← iOS / Android / Web
          │    App               │    / macOS / Linux / Windows
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

**Audio threat classes:** `gunshot` · `explosion` · `scream` · `glass_break` · `forced_entry` · `crying_distress` · `fight_sounds` · `siren` · `car_crash` · `threatening_voice`

**Visual threat classes:** `intruder_detected` · `weapon_detected` · `explosion` · `car_crash` · `abuse` · `fighting` · `assault` · `robbery` · `person_down` · `forced_entry`

**Severity levels:**

| Level | Example triggers |
|---|---|
| 🔴 High | weapon detected, gunshot, explosion, assault, abuse, person down |
| 🟡 Medium | intruder, car crash, glass break |
| 🟢 Low | siren, suspicious package |

### Fusion Logic

- **Confidence floor** — predictions below 0.25 are discarded as noise.
- **Cross-modal consistency** — if audio and visual labels are semantically incompatible (e.g. `gunshot` audio with `car_crash` visual), the audio prediction is overridden and its confidence is penalised 70%.
- **Agreement bonus** — when both modalities agree on the same label, the fused score is boosted 15%.
- **Disagreement penalty** — conflicting non-normal labels are averaged with an 85% multiplier.

### Backend

- **FastAPI** with async WebSocket connection manager (per-user channels).
- **SQLAlchemy + PostgreSQL** — `Event`, `Alert`, and `User` ORM tables.
- **JWT authentication** — HMAC-SHA256 signed tokens with expiry.
- **Demo broadcast endpoint** — pushes simulation events to every registered user; deduplicates alerts per threat type per run.
- **Snapshot serving** — static endpoint for JPEG frame snapshots linked to alerts.

### Mobile App (Flutter)

| Screen | Description |
|---|---|
| Login / Sign-up | Secure auth with token stored in device secure storage |
| Dashboard | Live status, active alerts, camera feed overview |
| Alerts | Real-time alert list, severity badges, snapshot previews |
| Alert Detail | Full event detail with confidence scores and snapshot image |
| Analytics | Charts (`fl_chart`) over historical event data |
| History | Full event log with confidence scores and fusion results |
| Account | User profile and notification settings |

Real-time updates are driven by a `WebSocketService` provider; the app also polls the REST API as a fallback.

---

## Project Structure

```
ai_survaillance/
├── ai_models/
│   ├── __init__.py
│   ├── audio/
│   │   ├── audio_model.py              # AudioCNN + AudioAnomalyDetector
│   │   ├── train_audio_model.py        # Full training pipeline
│   │   └── saved_model/               # best_model.pth + labels.json
│   ├── visual/
│   │   ├── visual_model.py             # VisualAnomalyDetector (ResNet18 + YOLOv8n)
│   │   ├── train_visual_classifier.py  # Fine-tuning script (ResNet18)
│   │   ├── train_visual_model.py       # Alternative training script
│   │   ├── classifier_frames/          # Frame dataset for classifier
│   │   ├── weapon_dataset/             # Dataset for weapon detection
│   │   └── saved_model/               # best_classifier.pth + YOLO weights
│   └── fusion/
│       ├── fusion_engine.py            # FusionEngine + abandoned-object tracker
│       └── alert_logic.py             # AlertLogic (threshold → fire/suppress)
│
├── backend/
│   ├── main.py                         # FastAPI app entry point + WebSocket manager
│   ├── api/
│   │   └── routes/
│   │       ├── auth.py                 # Register / login / JWT token
│   │       ├── events.py              # Event CRUD + demo_broadcast
│   │       ├── alerts.py              # Alert retrieval
│   │       └── stats.py               # Aggregated analytics
│   ├── database/
│   │   ├── models.py                  # Event, Alert, User ORM models
│   │   └── db.py                      # SQLAlchemy engine + session factory
│   ├── services/
│   │   └── notifier.py                # NotificationService (WebSocket dispatch)
│   └── static/                        # Served JPEG snapshots
│
├── simulation/
│   ├── runner.py                       # Runs all scenarios end-to-end
│   ├── demo_video_runner.py            # Plays demo MP4s through the full AI pipeline
│   ├── generate_synthetic_audio.py     # Synthetic audio generation utility
│   ├── base.py                         # Scenario loader (audio + visual assets)
│   ├── demo1.mp4 … demo6.mp4          # Demo video files for the pipeline
│   ├── datasets/                       # Audio/video sample datasets
│   ├── scenarios/                      # One module per threat type
│   │   ├── normal.py
│   │   ├── gunshot.py
│   │   ├── explosion.py
│   │   ├── forced_entry.py
│   │   ├── intruder_detected.py
│   │   ├── weapon_detected.py
│   │   ├── car_crash.py
│   │   ├── person_down.py
│   │   └── suspicious_package.py
│   └── input_gen/                      # Synthetic audio / video generators
│       ├── audio_sim.py
│       └── video_sim.py
│
├── mobile_app/                         # Flutter project
│   └── lib/
│       ├── main.dart                   # App entry point + routing
│       ├── models/
│       │   ├── alert_model.dart
│       │   └── user_model.dart
│       ├── providers/
│       │   ├── auth_provider.dart
│       │   └── alert_provider.dart
│       ├── screens/
│       │   ├── login_screen.dart
│       │   ├── signup_screen.dart
│       │   ├── dashboard_screen.dart
│       │   ├── alerts_screen.dart
│       │   ├── alert_detail_screen.dart
│       │   ├── analytics_screen.dart
│       │   ├── history_screen.dart
│       │   └── account_screen.dart
│       ├── services/
│       │   ├── api_service.dart
│       │   ├── websocket_service.dart
│       │   ├── notification_service.dart
│       │   └── secure_storage_service.dart
│       └── widgets/
│           ├── alert_card.dart
│           └── stat_card.dart
│
├── evaluate_models.py                  # Offline model evaluation script
├── seed_db.py                          # Database seed script
├── requirements.txt                    # Python dependencies
├── yolov8n.pt                          # YOLOv8n base weights
├── yolo26n.pt                          # YOLO v26n weights variant
├── .env.example                        # Environment variable template
└── .gitignore
```

---

## Tech Stack

| Layer | Technology | Version |
|---|---|---|
| AI / ML | PyTorch | 2.10.0 |
| AI / ML | torchvision | 0.25.0 |
| AI / ML | Librosa | 0.11.0 |
| AI / ML | OpenCV | 4.13.0 |
| AI / ML | Ultralytics YOLOv8 | 8.4.23 |
| Backend | FastAPI | 0.135.1 |
| Backend | SQLAlchemy | 2.0.48 |
| Backend | PostgreSQL (psycopg2-binary) | 2.9.11 |
| Backend | Uvicorn | 0.42.0 |
| Mobile | Flutter / Dart | SDK 3.x |
| Mobile | Provider, fl_chart, web_socket_channel | — |
| Hardware acceleration | Apple MPS (M-series) / CUDA | — |

---

## Setup Guide

### Prerequisites

| Requirement | Version |
|---|---|
| Python | 3.11+ |
| PostgreSQL | 14+ |
| Flutter SDK | 3.x |
| Apple Silicon Mac | Optional (MPS acceleration) |

---

### Step 1 — Clone the Repository

```bash
git clone <repository-url>
cd ai_survaillance
```

---

### Step 2 — Python Environment

```bash
python -m venv venv
source venv/bin/activate          # macOS / Linux
# venv\Scripts\activate           # Windows

pip install -r requirements.txt
```

---

### Step 3 — Environment Variables

Copy the example file and fill in your credentials:

```bash
cp .env.example .env
```

Edit `.env`:

```env
DATABASE_URL=postgresql://user:password@localhost:5432/surveillance
SECRET_KEY=your_secret_key_here
```

| Variable | Description |
|---|---|
| `DATABASE_URL` | Full PostgreSQL connection string |
| `SECRET_KEY` | Random string used to sign JWT tokens (keep private) |

---

### Step 4 — Database Initialisation

Tables are created automatically on the first backend start. To pre-seed the database with sample data:

```bash
python seed_db.py
```

---

### Step 5 — Train the Models *(optional — pre-trained weights included)*

Pre-trained weights are already included in `ai_models/*/saved_model/` and can be used immediately. Skip this step unless you want to retrain.

```bash
# Train the audio model
python ai_models/audio/train_audio_model.py

# Train the visual classifier (ResNet18)
python ai_models/visual/train_visual_classifier.py

# Alternative visual model training
python ai_models/visual/train_visual_model.py
```

---

### Step 6 — Start the Backend

```bash
uvicorn backend.main:app --reload --host 0.0.0.0 --port 8000
```

- Interactive API docs: [http://localhost:8000/docs](http://localhost:8000/docs)
- Alternative docs (ReDoc): [http://localhost:8000/redoc](http://localhost:8000/redoc)

---

### Step 7 — Run the Simulation

```bash
# Run all pre-defined threat scenarios end-to-end
python simulation/runner.py

# Stream demo MP4 files through the full AI pipeline (recommended for live demo)
python simulation/demo_video_runner.py

# Generate synthetic audio samples
python simulation/generate_synthetic_audio.py
```

The `demo_video_runner.py` script processes each demo video (`demo1.mp4` – `demo6.mp4`) frame-by-frame, passes audio and visual data through the AI models and fusion engine, and broadcasts results via WebSocket to any connected mobile app.

---

### Step 8 — Evaluate Models *(optional)*

```bash
python evaluate_models.py
```

Prints per-class accuracy, confusion matrix, and confidence metrics for both audio and visual models.

---

### Step 9 — Mobile App

```bash
cd mobile_app
flutter pub get
flutter run              # auto-detects connected device / simulator
```

To target a specific platform:

```bash
flutter run -d ios       # iOS simulator or device
flutter run -d android   # Android emulator or device
flutter run -d chrome    # Web (Chrome)
flutter run -d macos     # macOS desktop
```

---

## User Guide

### Running a Live Demo (Recommended Quick Start)

The fastest way to see the system in action:

1. **Start the backend** (Step 6 above).
2. **Launch the mobile app** and log in (or create an account via Sign-up).
3. In a separate terminal, **run the video demo runner**:
   ```bash
   python simulation/demo_video_runner.py
   ```
4. Watch real-time alerts appear on the mobile app as the AI processes each video.

---

### Mobile App Walkthrough

#### Login / Sign-up

- Open the app; you will see the **Login** screen.
- New users: tap **Sign up** to create an account using an email and password.
- Returning users: enter credentials and tap **Login**.
- The JWT token is stored securely on-device and refreshed automatically.

#### Dashboard

- Displays a **live status indicator** (connected / disconnected).
- Shows **active high-severity alerts** at a glance.
- Provides a **camera feed overview** panel.
- The status dot in the header shows the WebSocket connection health.

#### Alerts Screen

- Lists all active alerts sorted by time, newest first.
- Each **alert card** shows:
  - Threat type and severity badge (High 🔴 / Medium 🟡 / Low 🟢)
  - Timestamp
  - Fused confidence score
  - Snapshot thumbnail (if available)
- Tap any card to open the **Alert Detail** screen.

#### Alert Detail Screen

- Full-resolution **snapshot image** of the frame that triggered the alert.
- Breakdown of audio prediction, visual prediction, and final fused result.
- Confidence scores for both modalities.

#### Analytics Screen

- Charts powered by `fl_chart` showing:
  - Alert frequency over time
  - Threat type distribution
  - Severity breakdown
- Use the time-range selector to filter historical data.

#### History Screen

- Complete event log (including non-alert events).
- Shows fusion result, confidence, and timestamp for every processed frame.

#### Account Screen

- Update your display name and email.
- Manage **notification preferences** (push / silent).
- Log out.

---

### Running Specific Scenarios

Each scenario module in `simulation/scenarios/` can be run individually for targeted testing:

```bash
# Example: test only the gunshot scenario
python -c "
from simulation.scenarios.gunshot import GunShotScenario
s = GunShotScenario()
s.run()
"
```

---

### Resetting a Demo Broadcast Session

The backend deduplicates alerts per threat type within a single broadcast session. To reset and allow the same threats to fire again:

```bash
curl -X POST http://localhost:8000/events/demo_broadcast/reset
```

Or use the Swagger UI at `http://localhost:8000/docs`.

---

### Offline Model Evaluation

```bash
python evaluate_models.py
```

This script loads the saved weights from `ai_models/*/saved_model/`, runs the test split, and prints:
- Per-class precision / recall / F1
- Confusion matrix
- Overall accuracy

---

## API Reference

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `POST` | `/auth/register` | ❌ | Create a new user account |
| `POST` | `/auth/login` | ❌ | Authenticate and receive JWT token |
| `GET` | `/events/` | ✅ JWT | List events for the authenticated user |
| `POST` | `/events/` | ✅ JWT | Store an AI-processed event |
| `POST` | `/events/demo_broadcast` | ❌ | Broadcast a simulation event to all users |
| `POST` | `/events/demo_broadcast/reset` | ❌ | Clear per-session deduplication state |
| `GET` | `/alerts/` | ✅ JWT | List alerts for the authenticated user |
| `GET` | `/stats/` | ✅ JWT | Aggregated analytics data |
| `WS` | `/ws/{user_id}` | — | Real-time WebSocket alert channel |

Full interactive documentation: [http://localhost:8000/docs](http://localhost:8000/docs)

---

## Simulation Scenarios

The runner exercises 9 defined scenarios covering the core threat taxonomy:

| Scenario | Trigger |
|---|---|
| `normal` | Background / no threat |
| `gunshot` | Gunshot audio |
| `explosion` | Explosion audio + visual |
| `forced_entry` | Forced entry audio + visual |
| `intruder_detected` | Visual intruder detection |
| `weapon_detected` | YOLOv8n weapon detection |
| `car_crash` | Car crash audio + visual |
| `person_down` | Visual person-down detection |
| `suspicious_package` | Abandoned object (60 s timer) |

Each scenario loads matching audio and video samples, runs them through both AI models, fuses the results, and validates the output severity against the expected value.

---

## Troubleshooting

| Problem | Solution |
|---|---|
| `psycopg2` connection refused | Ensure PostgreSQL is running: `brew services start postgresql` |
| `ModuleNotFoundError` | Make sure the venv is active: `source venv/bin/activate` |
| YOLO weights missing | The `yolov8n.pt` and `yolo26n.pt` files must be in the project root |
| Mobile app won't connect | Set the backend IP in `lib/services/api_service.dart` to your machine's local IP (not `localhost` on a physical device) |
| MPS not available | Ensure you are on an Apple Silicon Mac with macOS 12.3+; the code falls back to CPU automatically |
| `SECRET_KEY` error on startup | Make sure `.env` exists with a non-empty `SECRET_KEY` value |
