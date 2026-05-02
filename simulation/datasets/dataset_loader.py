import os
import librosa
import numpy as np
import cv2
from pathlib import Path


class AudioDatasetLoader:
    def __init__(self, base_path="simulation/datasets/audio"):
        self.base_path = base_path
        self.sr = 22050
        self.classes = [
            "normal",
            "gunshot",
            "explosion",
            "scream",
            "glass_break",
            "forced_entry",
            "crying_distress",
            "fight_sounds",
            "siren",
            "car_crash",
            "threatening_voice",
        ]

    def load_class(self, class_name: str):
        class_path = os.path.join(self.base_path, class_name)
        if not os.path.exists(class_path):
            print(f"No folder found for {class_name}")
            return []

        samples = []
        for file in Path(class_path).glob("*.wav"):
            try:
                audio, sr = librosa.load(str(file), sr=self.sr)
                samples.append({
                    "audio": audio,
                    "sr": sr,
                    "label": class_name,
                    "file": str(file),
                })
            except Exception as e:
                print(f"Could not load {file}: {e}")

        return samples

    def load_all(self):
        all_samples = []
        for cls in self.classes:
            samples = self.load_class(cls)
            all_samples.extend(samples)
        print(f"\nTotal audio samples loaded: {len(all_samples)}")
        return all_samples

    def get_stats(self):
        print("\nAudio dataset statistics:")
        print("-" * 40)
        total = 0
        for cls in self.classes:
            path = os.path.join(self.base_path, cls)
            if os.path.exists(path):
                count = len(list(Path(path).glob("*.wav")))
                total += count
                if count >= 20:
                    status = "✓"
                elif count > 0:
                    status = "⚠ need more"
                else:
                    status = "✗ empty"
                print(f"{cls:<25} {count:>3} files  {status}")
            else:
                print(f"{cls:<25}   0 files  ✗ folder missing")
        print("-" * 40)
        print(f"Total: {total} audio files")
        print(f"Target: {len(self.classes) * 20} files (20 per class)")


class VideoDatasetLoader:
    def __init__(self, base_path="simulation/datasets/video"):
        self.base_path = base_path
        self.classes = [
            "normal",
            "intruder_detected",
            "weapon_detected",
            "explosion",
            "vehicle_intrusion",
            "abuse",
            "fighting",
            "assault",
            "robbery",
            "person_down",
            "forced_entry",
            "suspicious_package",
        ]

    def load_frame(self, video_path: str):
        try:
            cap = cv2.VideoCapture(video_path)
            ret, frame = cap.read()
            cap.release()
            if ret:
                return frame
        except Exception as e:
            print(f"Could not load {video_path}: {e}")
        return None

    def load_class(self, class_name: str):
        class_path = os.path.join(self.base_path, class_name)
        if not os.path.exists(class_path):
            print(f"No folder found for {class_name}")
            return []

        samples = []
        for ext in ["*.mp4", "*.avi", "*.mov"]:
            for file in Path(class_path).glob(ext):
                frame = self.load_frame(str(file))
                if frame is not None:
                    samples.append({
                        "frame": frame,
                        "label": class_name,
                        "file": str(file),
                    })
        return samples

    def load_all(self):
        all_samples = []
        for cls in self.classes:
            samples = self.load_class(cls)
            all_samples.extend(samples)
        print(f"\nTotal video samples loaded: {len(all_samples)}")
        return all_samples

    def get_stats(self):
        print("\nVideo dataset statistics:")
        print("-" * 40)
        total = 0
        for cls in self.classes:
            path = os.path.join(self.base_path, cls)
            if os.path.exists(path):
                count = 0
                for ext in ["*.mp4", "*.avi", "*.mov"]:
                    count += len(list(Path(path).glob(ext)))
                total += count
                if count >= 20:
                    status = "✓"
                elif count > 0:
                    status = "⚠ need more"
                else:
                    status = "✗ empty"
                print(f"{cls:<25} {count:>3} files  {status}")
            else:
                print(f"{cls:<25}   0 files  ✗ folder missing")
        print("-" * 40)
        print(f"Total: {total} video files")
        print(f"Target: {len(self.classes) * 20} files (20 per class)")


if __name__ == "__main__":
    audio_loader = AudioDatasetLoader()
    audio_loader.get_stats()

    video_loader = VideoDatasetLoader()
    video_loader.get_stats()