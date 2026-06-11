# AI Surveillance System

An intelligent audio-visual fusion surveillance platform that detects security threats in real time by combining deep learning on audio and video streams. Alerts are delivered instantly to a cross-platform Flutter mobile app via WebSockets.

---

## Team

| Name | Student No | Role |
|------|-----------|------|
| Derya Akıncı | 22450272 | Project Manager / AI Developer |
| Ege İşcan | 22000344 | Backend Developer |
| Alper Hatipoğlu | 21000058 | Frontend Developer |

**Supervisor:** Prof. Dr. Ekrem Varoğlu  
**Course:** CMPE 406 – Graduation Project  
**University:** Eastern Mediterranean University  
**Semester:** Spring 2025–2026
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
          │  │AudioAnomalyDe- │  │  ← 7 classes (6 threats + normal)
          │  │   tector       │  │    3-block Conv2D, Mel-spectrograms
          │  │  (AudioCNN)    │  │    silence guard · top-2 check
          │  └───────┬────────┘  │
          │  ┌───────▼────────┐  │
          │  │VisualAnomaly   │  │  ← EfficientNet-V2-S classifier
          │  │  Detector      │  │    + dedicated Weapon YOLO
          │  │(EfficientNet + │  │    + YOLOv8n knife fallback
          │  │  Weapon YOLO)  │  │    5-view TTA · 2-frame streak guard
          │  └───────┬────────┘  │
          │  ┌───────▼────────┐  │
          │  │ FusionEngine   │  │  ← Confidence floors
          │  └───────┬────────┘  │     cross-modal upgrade / override
          └──────────┼───────────┘     weapon upgrade · severity scoring
                     │                 abandoned-object tracker
          ┌──────────▼───────────┐
          │   FastAPI Backend    │  ← REST + WebSocket
          │   PostgreSQL / ORM   │    JWT authentication
          │   Static snapshots   │
          └──────────┬───────────┘
                     │ WebSocket / REST
          ┌──────────▼───────────┐
          │    Flutter Mobile    │  ← iOS / Web
          │    App               │    / macOS / Windows
          └──────────────────────┘
```

---

## Features

### AI Models

| Layer | Class | Backbone | Details |
|---|---|---|---|
| Audio | `AudioAnomalyDetector` | `AudioCNN` | 3-block Conv2D on 128-band Mel-spectrograms; silence guard skips inference when peak amplitude < 0.002; top-2 softmax borderline check |
| Visual | `VisualAnomalyDetector` | EfficientNet-V2-S + YOLOv8 | EfficientNet-V2-S multi-label classifier with 5-view TTA; dedicated weapon YOLO (guns + knives); base YOLOv8n knife-only fallback; 2-frame streak guard on weapon alerts |
| Fusion | `FusionEngine` | — | Confidence floors, cross-modal upgrade/override, weapon upgrade, agreement/penalty scoring, severity assignment |
| Object Tracking | `FusionEngine` | — | Abandoned-object detection: ownership registry, 60 s stationary timer, 5.0-unit owner-distance trigger |

**Audio classes (7):** `normal` · `gunshot` · `impact` · `distress_sounds` · `forced_entry` · `fight_sounds` · `siren`

**Visual classes (7):** `normal` · `weapon_detected` · `explosion` · `car_crash` · `violence` · `person_down` · `intrusion_detected`

**Visual inference details:**
- Default confidence threshold: **0.55**; per-class override: `violence` → **0.35** (improves recall when weapon activation suppresses it)
- Priority order (most critical first): `weapon_detected` › `explosion` › `person_down` › `violence` › `intrusion_detected` › `car_crash`
- If the highest-confidence anomaly outscores the primary by > 0.15, the primary is re-ranked by confidence
- `weapon_detected` is excluded from the EfficientNet head — YOLO is the sole weapon authority

**Severity levels:**

| Level | Triggers |
|---|---|
| 🔴 High | `weapon_detected` · `person_down` · `explosion` · `intrusion_detected` · `violence` · `gunshot` · `distress_sounds` · `fight_sounds` · `forced_entry` · `impact` |
| 🟡 Medium | `car_crash` · `suspicious_package` |
| 🟢 Low | everything else |

### Fusion Logic

The `FusionEngine.fuse()` method runs the following pipeline in order:

1. **Confidence floors** — audio below **0.35** and visual below **0.30** are demoted to `normal`.
2. **Audio suppression** — if visual is confidently normal (≥ 0.90), an audio-only anomaly is suppressed.
3. **Cross-modal upgrade** — if visual is uncertain (0.40–0.80 "normal" confidence) but audio is anomalous, the visual label is upgraded to a compatible threat class using a fixed mapping (`gunshot` → `weapon_detected`, `fight_sounds`/`distress_sounds` → `violence`, `forced_entry` → `intrusion_detected`, `impact` → `car_crash`, `siren` → `intrusion_detected`) and floored at 0.60.
4. **Cross-modal consistency override** — when both modalities are anomalous but semantically incompatible (based on `AUDIO_VISUAL_COMPAT` map), audio is overridden to match the visual label and its confidence is penalised ×0.3. The floor check is re-applied after this penalty.
5. **Weak visual suppression** — a visual-only anomaly below **0.70** (non-critical) or **0.60** (critical) is suppressed when audio is confidently silent.
6. **Weapon upgrade** — `gunshot` audio + `violence` / `intrusion_detected` / `person_down` visual → promoted to `weapon_detected` (visual confidence floored at 0.65).
7. **Fused score**:
   - Both modalities agree → `max(a_conf, v_conf) × 1.15` (15 % boost, capped at 1.0)
   - Both anomalous but different → `max(a_conf, v_conf) × 0.85` (15 % penalty)
   - One modality fires → raw `max(a_conf, v_conf)`
8. **Alert flag** — set if either label is non-normal or any secondary visual detection ≥ 0.50 is a critical class.

**`AUDIO_VISUAL_COMPAT` map** (audio label → acceptable visual labels):

| Audio | Compatible Visual Labels |
|---|---|
| `gunshot` | `weapon_detected`, `violence`, `person_down` |
| `impact` | `explosion`, `person_down`, `car_crash` |
| `distress_sounds` | `violence`, `person_down`, `intrusion_detected` |
| `forced_entry` | `intrusion_detected` |
| `fight_sounds` | `violence`, `person_down`, `weapon_detected`, `intrusion_detected` |
| `siren` | `car_crash`, `person_down`, `explosion` |

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

## Troubleshooting

| Problem | Solution |
|---|---|
| `psycopg2` connection refused | Ensure PostgreSQL is running: `brew services start postgresql` |
| `ModuleNotFoundError` | Make sure the venv is active: `source venv/bin/activate` |
| YOLO weights missing | The `yolov8n.pt` and `yolo26n.pt` files must be in the project root |
| Mobile app won't connect | Set the backend IP in `lib/services/api_service.dart` to your machine's local IP (not `localhost` on a physical device) |
| MPS not available | Ensure you are on an Apple Silicon Mac with macOS 12.3+; the code falls back to CPU automatically |
| `SECRET_KEY` error on startup | Make sure `.env` exists with a non-empty `SECRET_KEY` value |
