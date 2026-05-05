"""
demo_video_runner.py
====================
Run a single MP4 / AVI / MOV video through both AI models and the fusion
engine for a live presentation demo.

The video must contain audio.  The script:
  1. Extracts audio from the video using ffmpeg (one-time step).
  2. Walks through the video in configurable time-chunks (default 3 s).
  3. For each chunk  → runs VisualAnomalyDetector on a sample frame
                      → runs AudioAnomalyDetector on the matching audio slice
                      → fuses both results and checks alert logic.
  4. Prints a live, colour-coded timeline to the terminal.

Usage (from project root):
    python -m simulation.demo_video_runner --video path/to/your_video.mp4

Optional flags:
    --chunk_sec   Duration of each analysis chunk in seconds (default 3)
    --fps_sample  Which frame inside the chunk to sample for visual (default 1
                  = first frame of the chunk). Set to 'mid' to grab the middle.
    --no_color    Disable ANSI colours (for plain terminal / log file output).
"""

import argparse
import os
import sys
import subprocess
import tempfile
import threading
import time

import cv2
import numpy as np

# ── project root on sys.path ───────────────────────────────────────────────
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from ai_models.audio.audio_model import AudioAnomalyDetector
from ai_models.visual.visual_model import VisualAnomalyDetector
from ai_models.fusion.fusion_engine import FusionEngine
from ai_models.fusion.alert_logic import AlertLogic


# ── ANSI colours ──────────────────────────────────────────────────────────
class C:
    RED    = "\033[91m"
    YELLOW = "\033[93m"
    GREEN  = "\033[92m"
    CYAN   = "\033[96m"
    BOLD   = "\033[1m"
    DIM    = "\033[2m"
    RESET  = "\033[0m"

_use_color = True

def _c(code, text):
    return f"{code}{text}{C.RESET}" if _use_color else text


# ── helpers ───────────────────────────────────────────────────────────────

def _check_ffmpeg():
    try:
        subprocess.run(
            ["ffmpeg", "-version"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True,
        )
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False


def extract_audio_wav(video_path: str, out_wav: str, sr: int = 22050):
    """Extract mono audio from the video to a temporary WAV file."""
    cmd = [
        "ffmpeg", "-y",
        "-i", video_path,
        "-ac", "1",          # mono
        "-ar", str(sr),      # target sample rate
        "-vn",               # no video stream
        out_wav,
    ]
    result = subprocess.run(
        cmd,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.PIPE,
    )
    if result.returncode != 0:
        raise RuntimeError(
            f"ffmpeg failed to extract audio:\n{result.stderr.decode()}"
        )


def load_wav_numpy(wav_path: str, sr: int = 22050) -> np.ndarray:
    """Load a WAV file to a float32 numpy array using librosa."""
    import librosa
    audio, _ = librosa.load(wav_path, sr=sr, mono=True)
    return audio.astype(np.float32)


def sample_frame(video_path: str, timestamp_sec: float) -> np.ndarray | None:
    """Return a BGR frame at `timestamp_sec` from the video."""
    cap = cv2.VideoCapture(video_path)
    cap.set(cv2.CAP_PROP_POS_MSEC, timestamp_sec * 1000)
    ret, frame = cap.read()
    cap.release()
    return frame if ret else None


def best_visual_in_chunk(
    video_path: str,
    visual_model,
    chunk_start: float,
    chunk_end: float,
    n_samples: int = 5,
) -> dict:
    """
    Sample n_samples evenly-spaced frames across the chunk and return
    the most alarming visual result (anomaly > normal, then highest
    severity, then highest confidence).
    """
    SEVERITY_RANK = {"high": 3, "medium": 2, "low": 1, "": 0}
    HIGH = {"weapon_detected", "person_down", "explosion", "robbery",
            "forced_entry", "assault", "abuse"}
    MEDIUM = {"intruder_detected", "vehicle_intrusion", "fighting",
              "suspicious_package", "glass_break", "crying_distress", "car_crash"}

    def _sev(label):
        if label in HIGH:
            return "high"
        if label in MEDIUM:
            return "medium"
        if label != "normal":
            return "low"
        return ""

    best_result = {"label": "normal", "confidence": 0.0}
    best_rank   = (-1, 0.0)   # (severity_rank, confidence)

    step = (chunk_end - chunk_start) / max(n_samples - 1, 1)
    for i in range(n_samples):
        t = chunk_start + i * step
        frame = sample_frame(video_path, t)
        if frame is None:
            continue
        result = visual_model.predict(frame)
        label  = result.get("label", "normal")
        conf   = result.get("confidence", 0.0)
        srank  = SEVERITY_RANK.get(_sev(label), 0)
        rank   = (srank, conf)
        if rank > best_rank:
            best_rank   = rank
            best_result = result

    return best_result


def severity_color(severity: str) -> str:
    if severity == "high":
        return C.RED
    if severity == "medium":
        return C.YELLOW
    return C.GREEN


def format_timestamp(seconds: float) -> str:
    m, s = divmod(int(seconds), 60)
    return f"{m:02d}:{s:02d}"


# ── API Integration ────────────────────────────────────────────────────────

def setup_api_session(base_url="http://localhost:8000"):
    import requests
    try:
        # Just check if the server is alive
        requests.get(base_url, timeout=2)
        # Reset deduplication state for fresh demo run
        requests.post(f"{base_url}/events/demo_broadcast/reset", timeout=2)
        return {"base_url": base_url}
    except:
        return None

def post_event(session_info, audio_result, visual_result, fusion_result, alert_fired, frame=None):
    if not session_info:
        return
    import requests

    snapshot_filename = ""

    # Save frame snapshot when an alert fires
    if alert_fired and frame is not None:
        snapshot_dir = os.path.join(ROOT, "backend", "static", "snapshots")
        os.makedirs(snapshot_dir, exist_ok=True)
        snapshot_filename = f"snap_{int(time.time() * 1000)}.jpg"
        snapshot_path = os.path.join(snapshot_dir, snapshot_filename)
        cv2.imwrite(snapshot_path, frame)

    try:
        requests.post(
            f"{session_info['base_url']}/events/demo_broadcast",
            params={
                "audio_label": fusion_result["audio_label"],
                "visual_label": fusion_result["visual_label"],
                "audio_confidence": audio_result["confidence"],
                "visual_confidence": visual_result["confidence"],
                "fusion_score": fusion_result["fused_score"],
                "alert_fired": alert_fired,
                "severity": fusion_result["severity"],
                "zone": "Demo Camera",
                "snapshot_filename": snapshot_filename,
            },
            timeout=2
        )
    except Exception:
        pass


# ── main analysis loop ────────────────────────────────────────────────────

def run_demo(
    video_path: str,
    chunk_sec: int = 3,
):
    if not os.path.isfile(video_path):
        print(_c(C.RED, f"✗ Video not found: {video_path}"))
        sys.exit(1)

    print()
    print(_c(C.BOLD, "=" * 62))
    print(_c(C.BOLD + C.CYAN, "   AI SURVEILLANCE — DEMO VIDEO ANALYSER"))
    print(_c(C.BOLD, "=" * 62))
    print(f"  Video   : {video_path}")
    print(f"  Chunk   : {chunk_sec} s per analysis window")
    print()

    # ── load models ────────────────────────────────────────────────────────
    print("Loading models…")
    audio_model  = AudioAnomalyDetector()
    visual_model = VisualAnomalyDetector()
    fusion       = FusionEngine()
    alert_logic  = AlertLogic()
    print("Models ready.\n")

    print("Connecting to backend API (for real-time dashboard)...")
    session_info = setup_api_session()
    if session_info:
        print(_c(C.GREEN, "  ✓ API Connected. Alerts will appear in dashboard!\n"))
    else:
        print(_c(C.YELLOW, "  ⚠ Local backend not running. Terminal-only mode.\n"))

    # ── get video duration ──────────────────────────────────────────────────
    cap = cv2.VideoCapture(video_path)
    fps           = cap.get(cv2.CAP_PROP_FPS) or 25
    total_frames  = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    cap.release()
    duration_sec  = total_frames / fps
    sr = 22050

    print(f"  Duration: {format_timestamp(duration_sec)}  ({duration_sec:.1f} s)")
    print(f"  FPS     : {fps:.1f}")
    print(f"  Chunks  : {int(duration_sec // chunk_sec) + 1}")
    print()

    # ── extract audio ──────────────────────────────────────────────────────
    has_ffmpeg = _check_ffmpeg()
    audio_array: np.ndarray | None = None

    if has_ffmpeg:
        print("Extracting audio with ffmpeg…")
        with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
            tmp_wav = tmp.name
        try:
            extract_audio_wav(video_path, tmp_wav, sr=sr)
            audio_array = load_wav_numpy(tmp_wav, sr=sr)
            print(f"  Audio   : {len(audio_array) / sr:.1f} s loaded  ✓\n")
        except RuntimeError as e:
            print(_c(C.YELLOW, f"  ⚠ Audio extraction failed — running visual-only: {e}\n"))
            audio_array = None
        finally:
            if os.path.exists(tmp_wav):
                os.remove(tmp_wav)
    else:
        print(_c(C.YELLOW,
            "  ⚠ ffmpeg not found — audio analysis disabled.\n"
            "    Install with: brew install ffmpeg\n"
        ))

    # ── analysis loop ──────────────────────────────────────────────────────
    print(_c(C.BOLD, "-" * 62))
    print(_c(C.BOLD, f"  {'TIME':<8} {'AUDIO LABEL':<22} {'VISUAL LABEL':<22} STATUS"))
    print(_c(C.BOLD, "-" * 62))

    chunk_start = 0.0
    total_alerts = 0
    high_count = medium_count = low_count = 0

    while chunk_start < duration_sec:
        chunk_end = min(chunk_start + chunk_sec, duration_sec)

        # ── visual: sample 5 frames across the chunk, use best result ─────────
        visual_result = best_visual_in_chunk(
            video_path, visual_model, chunk_start, chunk_end, n_samples=5
        )
        # Also grab a single mid-chunk frame for snapshot purposes
        t_frame = (chunk_start + chunk_end) / 2
        frame = sample_frame(video_path, t_frame)
        if frame is None:
            frame = np.zeros((480, 640, 3), dtype=np.uint8)

        # ── audio: slice from the full waveform ────────────────────────────
        if audio_array is not None:
            start_sample = int(chunk_start * sr)
            end_sample   = int(chunk_end   * sr)
            audio_chunk  = audio_array[start_sample:end_sample]
            if len(audio_chunk) == 0:
                audio_chunk = np.zeros(sr * chunk_sec, dtype=np.float32)
        else:
            # No ffmpeg — use silence so visual analysis still runs
            audio_chunk = np.zeros(sr * chunk_sec, dtype=np.float32)

        # ── run models ─────────────────────────────────────────────────────
        audio_result  = audio_model.predict(audio_chunk, sr)
        fusion_result = fusion.fuse(audio_result, visual_result)
        alert_fired   = alert_logic.should_send_alert(fusion_result)
        severity      = fusion_result["severity"]
        sc            = severity_color(severity)

        # ── build output line (use fused/corrected labels) ─────────────────
        ts       = format_timestamp(chunk_start)
        a_label  = fusion_result["audio_label"]
        v_label  = fusion_result["visual_label"]
        a_conf   = audio_result["confidence"]
        v_conf   = visual_result["confidence"]

        if alert_fired:
            total_alerts += 1
            if severity == "high":
                high_count += 1
                status = _c(C.RED + C.BOLD, "🚨 ALERT  HIGH")
            elif severity == "medium":
                medium_count += 1
                status = _c(C.YELLOW + C.BOLD, "⚠  ALERT  MEDIUM")
            else:
                low_count += 1
                status = _c(C.GREEN, "ℹ  ALERT  LOW")
        else:
            status = _c(C.DIM, "✓  clear")

        a_str = _c(sc if a_label != "normal" else C.DIM, f"{a_label} ({a_conf:.2f})")
        v_str = _c(sc if v_label != "normal" else C.DIM, f"{v_label} ({v_conf:.2f})")

        print(f"  {ts:<8} {a_str:<35} {v_str:<35} {status}")

        if alert_fired:
            fused = fusion_result["fused_score"]
            print(_c(C.DIM, f"           → fused_score={fused:.3f}  "
                f"audio_conf={a_conf:.2f}  visual_conf={v_conf:.2f}"))

        # Send to API if connected (pass frame for snapshot capture)
        # Use fusion_result["alert"] (raw anomaly flag) instead of the
        # locally-deduplicated alert_fired — let the backend handle dedup.
        post_event(session_info, audio_result, visual_result, fusion_result, fusion_result["alert"], frame)

        chunk_start += chunk_sec

    # ── summary ────────────────────────────────────────────────────────────
    print(_c(C.BOLD, "-" * 62))
    print()
    print(_c(C.BOLD, "  SUMMARY"))
    print(f"  Duration analysed : {format_timestamp(duration_sec)}")
    print(f"  Chunks processed  : {int(duration_sec // chunk_sec) + 1}")
    print(f"  Total alerts      : {_c(C.BOLD, str(total_alerts))}")
    print(f"  High severity     : {_c(C.RED,    str(high_count))}")
    print(f"  Medium severity   : {_c(C.YELLOW, str(medium_count))}")
    print(f"  Low severity      : {_c(C.GREEN,  str(low_count))}")
    print()
    if total_alerts == 0:
        print(_c(C.GREEN, "  ✓ No anomalies detected in this video."))
    else:
        print(_c(C.RED if high_count > 0 else C.YELLOW,
            f"  ⚠ {total_alerts} anomal{'y' if total_alerts == 1 else 'ies'} "
            "detected — review alerts above."
        ))
    print(_c(C.BOLD, "=" * 62))
    print()


# ── CLI ───────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Run a video through the AI Surveillance models for a demo."
    )
    parser.add_argument(
        "--video", "-v",
        required=True,
        help="Path to the demo video file (MP4, AVI, MOV). Must contain audio.",
    )
    parser.add_argument(
        "--chunk_sec", "-c",
        type=int,
        default=3,
        help="Length of each analysis window in seconds (default: 3).",
    )
    parser.add_argument(
        "--no_color",
        action="store_true",
        help="Disable ANSI colour output.",
    )
    args = parser.parse_args()

    if args.no_color:
        _use_color = False

    run_demo(
        video_path=args.video,
        chunk_sec=args.chunk_sec,
    )
