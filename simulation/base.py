import os
import numpy as np
import librosa
import cv2
from pathlib import Path


AUDIO_DATASET_PATH = "simulation/datasets/audio"
VIDEO_DATASET_PATH = "simulation/datasets/video"


def load_scenario(
    name: str,
    audio_label: str,
    visual_label: str,
    expected_severity: str,
) -> dict:
    audio, sr = _load_audio(audio_label)
    visual = _load_visual(visual_label)

    return {
        "name": name,
        "audio": audio,
        "sr": sr,
        "visual": visual,
        "expected_severity": expected_severity,
    }


def _load_audio(label: str):
    folder = os.path.join(AUDIO_DATASET_PATH, label)
    files = list(Path(folder).glob("*.wav")) if os.path.exists(folder) else []

    if not files:
        print(f"  [scenario] No audio files for '{label}' — using silence")
        return np.zeros(22050, dtype=np.float32), 22050

    file = files[np.random.randint(len(files))]
    audio, sr = librosa.load(str(file), sr=22050)
    return audio, sr


def _load_visual(label: str) -> dict:
    folder = os.path.join(VIDEO_DATASET_PATH, label)
    files = []
    if os.path.exists(folder):
        for ext in ["*.mp4", "*.avi", "*.mov"]:
            files.extend(list(Path(folder).glob(ext)))

    if not files:
        print(f"  [scenario] No video files for '{label}' — using blank frame")
        return {"frame": np.zeros((480, 640, 3), dtype=np.uint8)}

    video_path = files[np.random.randint(len(files))]
    cap = cv2.VideoCapture(str(video_path))
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    target_frame = np.random.randint(max(1, total_frames))
    cap.set(cv2.CAP_PROP_POS_FRAMES, target_frame)
    ret, frame = cap.read()
    cap.release()

    if not ret:
        return {"frame": np.zeros((480, 640, 3), dtype=np.uint8)}

    return {"frame": frame}