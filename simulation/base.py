import os
import numpy as np
import librosa
import cv2
from pathlib import Path


AUDIO_DATASET_PATH = "simulation/datasets/audio"
VIDEO_DATASET_PATH = "simulation/datasets/video"
IMAGE_DATASET_PATH = "simulation/datasets/image"


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
    # Try video folder first
    video_folder = os.path.join(VIDEO_DATASET_PATH, label)
    video_files = []
    if os.path.exists(video_folder):
        for ext in ["*.mp4", "*.avi", "*.mov"]:
            video_files.extend(list(Path(video_folder).glob(ext)))

    if video_files:
        video_path = video_files[np.random.randint(len(video_files))]
        cap = cv2.VideoCapture(str(video_path))
        total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
        target_frame = np.random.randint(max(1, total_frames))
        cap.set(cv2.CAP_PROP_POS_FRAMES, target_frame)
        ret, frame = cap.read()
        cap.release()
        if ret:
            return {"frame": frame}

    # Fall back to image folder
    image_folder = os.path.join(IMAGE_DATASET_PATH, label)
    image_files = []
    if os.path.exists(image_folder):
        for ext in ["*.jpg", "*.jpeg", "*.png", "*.bmp", "*.webp"]:
            image_files.extend(list(Path(image_folder).glob(ext)))

    if image_files:
        img_path = image_files[np.random.randint(len(image_files))]
        frame = cv2.imread(str(img_path))
        if frame is not None:
            return {"frame": frame}

    print(f"  [scenario] No data for '{label}' — using blank frame")
    return {"frame": np.zeros((480, 640, 3), dtype=np.uint8)}