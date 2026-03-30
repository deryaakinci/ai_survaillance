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


def severity_color(severity: str) -> str:
    if severity == "high":
        return C.RED
    if severity == "medium":
        return C.YELLOW
    return C.GREEN


def format_timestamp(seconds: float) -> str:
    m, s = divmod(int(seconds), 60)
    return f"{m:02d}:{s:02d}"


# ── main analysis loop ────────────────────────────────────────────────────

def run_demo(
    video_path: str,
    chunk_sec: int = 3,
    frame_position: str = "first",  # 'first', 'mid', or 'last'
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

        # ── visual: pick a frame within this chunk ─────────────────────────
        if frame_position == "mid":
            t_frame = (chunk_start + chunk_end) / 2
        elif frame_position == "last":
            t_frame = chunk_end - 0.1
        else:
            t_frame = chunk_start

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
        visual_result = visual_model.predict(frame)
        fusion_result = fusion.fuse(audio_result, visual_result)
        alert_fired   = alert_logic.should_send_alert(fusion_result)
        severity      = fusion_result["severity"]
        sc            = severity_color(severity)

        # ── build output line ──────────────────────────────────────────────
        ts       = format_timestamp(chunk_start)
        a_label  = audio_result["label"]
        v_label  = visual_result["label"]
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
        "--frame",
        choices=["first", "mid", "last"],
        default="mid",
        help="Which frame in each chunk to pass to the visual model (default: mid).",
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
        frame_position=args.frame,
    )
