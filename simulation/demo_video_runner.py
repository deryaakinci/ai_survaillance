

import argparse
import os
import sys
import subprocess
import tempfile
import time

import cv2
import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

from ai_models.audio.audio_model import AudioAnomalyDetector
from ai_models.visual.visual_model import VisualAnomalyDetector, CLASSIFIER_MODEL_PATH
from ai_models.fusion.fusion_engine import FusionEngine
from ai_models.fusion.alert_logic import AlertLogic

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
        "-ac", "1",
        "-ar", str(sr),
        "-vn",
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
    Sample n_samples evenly-spaced frames across the chunk and use
    **majority voting** to decide the chunk label.

    An anomaly is only reported if more than half the sampled frames
    agree on the same anomaly class.  This prevents single-frame
    false positives on out-of-distribution content (e.g. weather
    reports, news broadcasts).

    Exception: weapon_detected is always trusted if *any* frame
    reports it, because missing a weapon is far worse than a false
    positive.
    """
    from collections import Counter

    results = []
    step = (chunk_end - chunk_start) / max(n_samples - 1, 1)
    for i in range(n_samples):
        t = chunk_start + i * step
        frame = sample_frame(video_path, t)
        if frame is None:
            continue
        results.append(visual_model.predict(frame))

    if not results:
        return {"label": "normal", "confidence": 0.0, "_no_frames": True}

    PRIORITY_LABELS = ["weapon_detected", "explosion", "violence"]
    PRIORITY_MIN_FRAMES = {"weapon_detected": 1, "explosion": 2, "violence": 2}
    priority_hits = [r for r in results if r.get("label") in set(PRIORITY_LABELS)]
    prio_counts = Counter(r.get("label") for r in priority_hits)

    qualified = sorted(
        [(label, count) for label, count in prio_counts.items()
         if count >= PRIORITY_MIN_FRAMES.get(label, 2)],
        key=lambda x: (-x[1], PRIORITY_LABELS.index(x[0]) if x[0] in PRIORITY_LABELS else 99),
    )
    if qualified:
        primary_label = qualified[0][0]
        matching = [r for r in priority_hits if r.get("label") == primary_label]
        best_prio = max(matching, key=lambda r: r["confidence"])
        if len(qualified) > 1:
            secondary = []
            for sec_label, _ in qualified[1:]:
                sec_matching = [r for r in priority_hits if r.get("label") == sec_label]
                sec_best = max(sec_matching, key=lambda r: r["confidence"])
                secondary.append((sec_label, sec_best["confidence"]))
            result = dict(best_prio)
            existing_dets = list(best_prio.get("detections", [(primary_label, best_prio["confidence"])]))
            if not any(d[0] == primary_label for d in existing_dets):
                existing_dets = [(primary_label, best_prio["confidence"])] + existing_dets
            for sec in secondary:
                if not any(d[0] == sec[0] for d in existing_dets):
                    existing_dets.append(sec)
            result["detections"] = existing_dets
            return result
        return best_prio

    labels = [r.get("label", "normal") for r in results]
    label_counts = Counter(labels)
    majority_label, majority_count = label_counts.most_common(1)[0]

    if majority_label != "normal" and majority_count > len(results) / 2:
        matching = [r for r in results if r.get("label") == majority_label]
        avg_conf = sum(r["confidence"] for r in matching) / len(matching)
        best_frame = max(matching, key=lambda r: r["confidence"])
        result = {"label": majority_label, "confidence": round(avg_conf, 3)}
        if "detections" in best_frame:
            result["detections"] = best_frame["detections"]
        return result

    normal_confs = [r["confidence"] for r in results if r.get("label") == "normal"]
    avg_normal = sum(normal_confs) / len(normal_confs) if normal_confs else 0.9
    return {"label": "normal", "confidence": round(avg_normal, 3)}

def severity_color(severity: str) -> str:
    if severity == "high":
        return C.RED
    if severity == "medium":
        return C.YELLOW
    return C.GREEN

def format_timestamp(seconds: float) -> str:
    m, s = divmod(int(seconds), 60)
    return f"{m:02d}:{s:02d}"

def setup_api_session(base_url="http://localhost:8000"):
    import requests
    try:
        requests.get(base_url, timeout=2)
        requests.post(f"{base_url}/events/demo_broadcast/reset", timeout=2)
        return {"base_url": base_url}
    except:
        return None

def post_audio_alert(session_info, message: str):
    """Send an audio-not-present warning alert to the dashboard."""
    if not session_info:
        return
    import requests
    try:
        requests.post(
            f"{session_info['base_url']}/events/demo_broadcast",
            params={
                "audio_label": "no_audio",
                "visual_label": "N/A",
                "audio_confidence": 0.0,
                "visual_confidence": 0.0,
                "fusion_score": 0.0,
                "alert_fired": True,
                "severity": "medium",
                "zone": "Demo Camera",
                "snapshot_filename": "",
                "message": message,
            },
            timeout=2,
        )
    except Exception:
        pass

def post_event(session_info, audio_result, visual_result, fusion_result, alert_fired, frame=None):
    if not session_info:
        return
    import requests

    snapshot_filename = ""

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

    print("Loading models…")
    audio_model  = AudioAnomalyDetector()
    visual_model = VisualAnomalyDetector(debug=False)
    fusion       = FusionEngine()
    alert_logic  = AlertLogic()

    if not visual_model.is_ready():
        print()
        print(_c(C.RED + C.BOLD, "✗ DEMO ABORTED: Visual model not loaded."))
        print(_c(C.RED,
            "  The EfficientNet classifier was not found at:\n"
            f"  {CLASSIFIER_MODEL_PATH}\n"
            "\n"
            "  The demo requires a functioning visual model to run.\n"
            "  Train it first with:\n"
            "    python -m ai_models.visual.train_visual_classifier\n"
        ))
        sys.exit(1)

    print("Models ready.\n")

    print("Connecting to backend API (for real-time dashboard)...")
    session_info = setup_api_session()
    if session_info:
        print(_c(C.GREEN, "  ✓ API Connected. Alerts will appear in dashboard!\n"))
    else:
        print(_c(C.YELLOW, "  ⚠ Local backend not running. Terminal-only mode.\n"))


    cap = cv2.VideoCapture(video_path)
    fps           = cap.get(cv2.CAP_PROP_FPS) or 0
    total_frames  = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    # Check whether the file actually contains a video stream by trying to
    # read one frame.  Audio-only containers (e.g. MP3/AAC wrapped in MP4)
    # will open without error but return ret=False immediately.
    ret, _ = cap.read()
    cap.release()

    if not ret or fps == 0 or total_frames == 0:
        print()
        print(_c(C.RED + C.BOLD, "✗ DEMO ABORTED: No video stream detected."))
        print(_c(C.RED,
            "  The supplied file appears to contain audio only.\n"
            "  Audio-only input is not supported because audio analysis\n"
            "  alone is not reliable enough for surveillance decisions.\n"
            "\n"
            "  Please provide a video file that includes a video stream.\n"
        ))
        sys.exit(1)

    duration_sec  = total_frames / fps
    sr = 22050

    print(f"  Duration: {format_timestamp(duration_sec)}  ({duration_sec:.1f} s)")
    print(f"  FPS     : {fps:.1f}")
    print(f"  Chunks  : {int(duration_sec // chunk_sec) + 1}")
    print()

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
            _audio_warn = f"Audio not present in demo: extraction failed — {e}"
            print(_c(C.YELLOW, f"  ⚠ {_audio_warn}\n"))
            post_audio_alert(session_info, _audio_warn)
            audio_array = None
        finally:
            if os.path.exists(tmp_wav):
                os.remove(tmp_wav)
    else:
        _audio_warn = "Audio not present in demo: ffmpeg not found — audio analysis disabled."
        print(_c(C.YELLOW,
            f"  ⚠ {_audio_warn}\n"
            "    Install ffmpeg with: brew install ffmpeg\n"
        ))
        post_audio_alert(session_info, _audio_warn)

    print(_c(C.BOLD, "-" * 62))
    print(_c(C.BOLD, f"  {'TIME':<8} {'AUDIO LABEL':<22} {'VISUAL LABEL':<22} STATUS"))
    print(_c(C.BOLD, "-" * 62))

    chunk_start = 0.0
    total_alerts = 0
    high_count = medium_count = low_count = 0
    chunks_read = 0

    while chunk_start < duration_sec:
        chunk_end = min(chunk_start + chunk_sec, duration_sec)

        visual_result = best_visual_in_chunk(
            video_path, visual_model, chunk_start, chunk_end, n_samples=5
        )

        if visual_result.get("_no_frames"):
            chunk_start += chunk_sec
            continue

        chunks_read += 1
        t_frame = (chunk_start + chunk_end) / 2
        frame = sample_frame(video_path, t_frame)
        if frame is None:
            frame = np.zeros((480, 640, 3), dtype=np.uint8)

        if audio_array is not None:
            start_sample = int(chunk_start * sr)
            end_sample   = int(chunk_end   * sr)
            audio_chunk  = audio_array[start_sample:end_sample]
            if len(audio_chunk) == 0:
                audio_chunk = np.zeros(sr * chunk_sec, dtype=np.float32)
        else:
            audio_chunk = np.zeros(sr * chunk_sec, dtype=np.float32)

        audio_result  = audio_model.predict(audio_chunk, sr)
        fusion_result = fusion.fuse(audio_result, visual_result)
        alert_fired   = alert_logic.should_send_alert(fusion_result)
        severity      = fusion_result["severity"]
        sc            = severity_color(severity)

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

        if audio_result.get("silent"):
            a_str = _c(C.DIM, "no audio stream")
        else:
            a_str = _c(sc if a_label != "normal" else C.DIM, f"{a_label} ({a_conf:.2f})")
        detections = fusion_result.get("detections", [])
        if detections and len(detections) > 1:
            v_str = _c(sc, " + ".join(f"{l}({c:.2f})" for l, c in detections))
        else:
            v_str = _c(sc if v_label != "normal" else C.DIM, f"{v_label} ({v_conf:.2f})")

        print(f"  {ts:<8} {a_str:<35} {v_str:<35} {status}")

        if alert_fired:
            fused = fusion_result["fused_score"]
            print(_c(C.DIM, f"           → fused_score={fused:.3f}  "
                f"audio_conf={a_conf:.2f}  visual_conf={v_conf:.2f}"))

        
        if audio_result.get("silent"):
            fusion_result = dict(fusion_result)  
            fusion_result["audio_label"] = "no_audio_stream"
        post_event(session_info, audio_result, visual_result, fusion_result, fusion_result["alert"], frame)

        chunk_start += chunk_sec

    if chunks_read == 0:
        print()
        print(_c(C.RED + C.BOLD, "✗ DEMO ABORTED: Visual input failed."))
        print(_c(C.RED,
            "  Visual model could not read any frames in this video.\n"
            "  Check that the video file is not corrupted and that\n"
            "  OpenCV can open it on this system."
        ))
        sys.exit(1)

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
