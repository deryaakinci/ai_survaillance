import torch
import librosa
import numpy as np


class AudioAnomalyDetector:
    def __init__(self):
        self.labels = [
            "normal",
            "gunshot",
            "explosion",
            "scream",
            "glass_break",
            "break_in",
            "door_forced",
            "crying_distress",
            "fight_sounds",
            "alarm_triggered",
            "siren",
            "car_crash",
            "threatening_voice",
        ]
        self.device = torch.device(
            "mps" if torch.backends.mps.is_available() else "cpu"
        )

    def extract_features(self, audio_chunk, sr):
        mel = librosa.feature.melspectrogram(
            y=audio_chunk, sr=sr, n_mels=128
        )
        mel_db = librosa.power_to_db(mel, ref=np.max)
        mfcc = librosa.feature.mfcc(
            y=audio_chunk, sr=sr, n_mfcc=13
        )
        zcr = librosa.feature.zero_crossing_rate(audio_chunk)
        spectral_centroid = librosa.feature.spectral_centroid(
            y=audio_chunk, sr=sr
        )
        spectral_rolloff = librosa.feature.spectral_rolloff(
            y=audio_chunk, sr=sr
        )
        spectral_bandwidth = librosa.feature.spectral_bandwidth(
            y=audio_chunk, sr=sr
        )
        tempo, _ = librosa.beat.beat_track(y=audio_chunk, sr=sr)

        return {
            "mel": mel_db,
            "mfcc": mfcc,
            "zcr": float(np.mean(zcr)),
            "centroid": float(np.mean(spectral_centroid)),
            "rolloff": float(np.mean(spectral_rolloff)),
            "bandwidth": float(np.mean(spectral_bandwidth)),
            "energy": float(np.mean(np.abs(audio_chunk))),
            "rms": float(np.sqrt(np.mean(audio_chunk ** 2))),
            "tempo": float(tempo),
        }

    def predict(self, audio_chunk, sr):
        features = self.extract_features(audio_chunk, sr)

        energy = features["energy"]
        rms = features["rms"]
        zcr = features["zcr"]
        centroid = features["centroid"]
        rolloff = features["rolloff"]
        bandwidth = features["bandwidth"]
        tempo = features["tempo"]

        # Gunshot — very high energy burst, high frequency, sharp attack
        if energy > 0.10 and centroid > 4500 and zcr > 0.35:
            return {
                "label": "gunshot",
                "confidence": round(min(energy * 9, 0.98), 3),
            }

        # Explosion — very high energy, wide bandwidth, low-mid frequency
        if energy > 0.09 and bandwidth > 4000 and centroid < 4000:
            return {
                "label": "explosion",
                "confidence": round(min(energy * 8, 0.97), 3),
            }

        # Glass break — high ZCR, high frequency, sharp transient
        if energy > 0.06 and zcr > 0.30 and centroid > 3500:
            return {
                "label": "glass_break",
                "confidence": round(min(energy * 8, 0.95), 3),
            }

        # Break in attempt — repeated low thuds, low frequency, medium energy
        if 0.04 < energy < 0.09 and centroid < 1500 and zcr > 0.10:
            return {
                "label": "break_in",
                "confidence": round(min(energy * 7, 0.92), 3),
            }

        # Door forced — single high impact, low frequency
        if energy > 0.07 and centroid < 1200 and rms > 0.08:
            return {
                "label": "door_forced",
                "confidence": round(min(energy * 7, 0.91), 3),
            }

        # Scream — high energy, mid-high frequency, high ZCR
        if energy > 0.05 and 2000 < centroid < 5000 and zcr > 0.20:
            return {
                "label": "scream",
                "confidence": round(min(energy * 7, 0.94), 3),
            }

        # Crying in distress — sustained mid energy, mid frequency, low ZCR
        if 0.02 < energy < 0.06 and 500 < centroid < 2500 and zcr < 0.15:
            return {
                "label": "crying_distress",
                "confidence": round(min(energy * 6, 0.88), 3),
            }

        # Fight sounds — irregular high energy bursts, wide bandwidth
        if energy > 0.05 and bandwidth > 3000 and tempo > 120:
            return {
                "label": "fight_sounds",
                "confidence": round(min(energy * 7, 0.90), 3),
            }

        # Threatening voice — sustained mid energy, low frequency speech range
        if 0.03 < energy < 0.06 and 200 < centroid < 1000 and zcr < 0.12:
            return {
                "label": "threatening_voice",
                "confidence": round(min(energy * 5, 0.85), 3),
            }

        # Alarm triggered — repetitive mid-high frequency tone
        if 0.03 < energy < 0.07 and centroid > 2000 and zcr < 0.15:
            return {
                "label": "alarm_triggered",
                "confidence": round(min(energy * 6, 0.88), 3),
            }

        # Siren — oscillating high frequency, medium energy
        if 0.02 < energy < 0.06 and rolloff > 6000 and zcr > 0.12:
            return {
                "label": "siren",
                "confidence": round(min(energy * 5, 0.86), 3),
            }

        # Car crash — high impact burst, wide bandwidth, low frequency
        if energy > 0.06 and bandwidth > 5000 and centroid < 3000:
            return {
                "label": "car_crash",
                "confidence": round(min(energy * 7, 0.91), 3),
            }

        # Default — normal
        return {"label": "normal", "confidence": 0.95}

    def predict_from_file(self, file_path: str):
        try:
            audio, sr = librosa.load(file_path, sr=22050)
            return self.predict(audio, sr)
        except Exception as e:
            return {
                "label": "normal",
                "confidence": 0.0,
                "error": str(e),
            }

    def get_severity(self, label: str) -> str:
        high = [
            "gunshot",
            "explosion",
            "scream",
            "fight_sounds",
            "door_forced",
            "threatening_voice",
        ]
        medium = [
            "glass_break",
            "break_in",
            "crying_distress",
            "alarm_triggered",
            "car_crash",
        ]
        low = [
            "siren",
        ]

        if label in high:
            return "high"
        elif label in medium:
            return "medium"
        elif label in low:
            return "low"
        return "low"