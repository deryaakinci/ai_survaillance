"""
generate_synthetic_audio.py
===========================
Generate synthetic training data for minority audio classes by applying
diverse augmentations to existing samples.

For classes with < 20 real samples (fight_sounds: 4, car_crash: 6,
forced_entry: 12, gunshot: 21), this script creates additional training
examples using a combination of:

  1. Pitch shifting  (±1–5 semitones)
  2. Time stretching (0.7x–1.3x)
  3. Noise injection (Gaussian + pink noise)
  4. Volume scaling  (0.5x–2.0x)
  5. Random cropping + padding
  6. Reverb simulation (simple convolution with decaying impulse)
  7. Mixing two samples from the same class at different ratios

Target: bring each minority class to ~40 samples minimum.

Usage (from project root):
    python -m simulation.generate_synthetic_audio
"""

import os
import numpy as np
import librosa
import soundfile as sf
from pathlib import Path
from itertools import combinations


# ── Configuration ─────────────────────────────────────────────────────────
AUDIO_DATASET = "simulation/datasets/audio"
TARGET_SR = 22050
TARGET_MIN_SAMPLES = 40   # Minimum samples per class after generation

# Only augment classes below this threshold
MINORITY_THRESHOLD = 30

LABELS = [
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
]


# ── Augmentation functions ────────────────────────────────────────────────

def pitch_shift(audio: np.ndarray, sr: int) -> np.ndarray:
    """Shift pitch by ±1 to 5 semitones."""
    steps = np.random.choice([-5, -4, -3, -2, -1, 1, 2, 3, 4, 5])
    return librosa.effects.pitch_shift(audio, sr=sr, n_steps=steps)


def time_stretch(audio: np.ndarray) -> np.ndarray:
    """Stretch/compress time by 0.7x to 1.3x."""
    rate = np.random.uniform(0.7, 1.3)
    return librosa.effects.time_stretch(audio, rate=rate)


def add_noise(audio: np.ndarray) -> np.ndarray:
    """Add Gaussian noise at a random SNR."""
    snr_db = np.random.uniform(10, 25)
    signal_power = np.mean(audio ** 2)
    noise_power = signal_power / (10 ** (snr_db / 10))
    noise = np.sqrt(noise_power) * np.random.randn(len(audio))
    return (audio + noise).astype(np.float32)


def add_pink_noise(audio: np.ndarray) -> np.ndarray:
    """Add pink (1/f) noise."""
    n = len(audio)
    freqs = np.fft.rfftfreq(n)
    freqs[0] = 1  # avoid division by zero
    pink_spectrum = 1 / np.sqrt(freqs)
    white = np.random.randn(n)
    pink = np.fft.irfft(np.fft.rfft(white) * pink_spectrum, n=n)
    
    snr_db = np.random.uniform(12, 22)
    signal_power = np.mean(audio ** 2) + 1e-10
    pink_power = np.mean(pink ** 2) + 1e-10
    scale = np.sqrt(signal_power / (10 ** (snr_db / 10)) / pink_power)
    return (audio + scale * pink).astype(np.float32)


def volume_scale(audio: np.ndarray) -> np.ndarray:
    """Scale volume by 0.5x to 2.0x."""
    gain = np.random.uniform(0.5, 2.0)
    return (audio * gain).astype(np.float32)


def random_crop_pad(audio: np.ndarray, sr: int) -> np.ndarray:
    """Randomly crop a portion and pad back to original length."""
    original_len = len(audio)
    crop_ratio = np.random.uniform(0.6, 0.95)
    crop_len = int(original_len * crop_ratio)
    
    start = np.random.randint(0, max(1, original_len - crop_len))
    cropped = audio[start:start + crop_len]
    
    # Pad with silence to original length
    if len(cropped) < original_len:
        pad_before = np.random.randint(0, original_len - len(cropped))
        pad_after = original_len - len(cropped) - pad_before
        cropped = np.pad(cropped, (pad_before, pad_after))
    
    return cropped.astype(np.float32)


def add_reverb(audio: np.ndarray, sr: int) -> np.ndarray:
    """Simulate reverb with a simple decaying impulse response."""
    reverb_len = int(sr * np.random.uniform(0.1, 0.4))
    decay = np.exp(-np.linspace(0, 5, reverb_len))
    impulse = np.random.randn(reverb_len) * decay
    impulse[0] = 1.0
    impulse = impulse / np.sqrt(np.sum(impulse ** 2))
    
    reverbed = np.convolve(audio, impulse, mode="full")[:len(audio)]
    # Mix wet/dry
    wet = np.random.uniform(0.2, 0.5)
    return ((1 - wet) * audio + wet * reverbed).astype(np.float32)


def mix_samples(audio1: np.ndarray, audio2: np.ndarray) -> np.ndarray:
    """Mix two audio clips at a random ratio."""
    # Align lengths
    min_len = min(len(audio1), len(audio2))
    a1 = audio1[:min_len]
    a2 = audio2[:min_len]
    
    ratio = np.random.uniform(0.3, 0.7)
    mixed = ratio * a1 + (1 - ratio) * a2
    return mixed.astype(np.float32)


# ── Pipeline: chain multiple augmentations ────────────────────────────────

def create_augmented_sample(audio: np.ndarray, sr: int, variant: int) -> np.ndarray:
    """Apply a chain of augmentations based on the variant number."""
    aug = audio.copy()
    
    if variant % 7 == 0:
        aug = pitch_shift(aug, sr)
        aug = add_noise(aug)
    elif variant % 7 == 1:
        aug = time_stretch(aug)
        aug = volume_scale(aug)
    elif variant % 7 == 2:
        aug = pitch_shift(aug, sr)
        aug = add_reverb(aug, sr)
    elif variant % 7 == 3:
        aug = add_pink_noise(aug)
        aug = random_crop_pad(aug, sr)
    elif variant % 7 == 4:
        aug = time_stretch(aug)
        aug = pitch_shift(aug, sr)
        aug = add_noise(aug)
    elif variant % 7 == 5:
        aug = volume_scale(aug)
        aug = add_reverb(aug, sr)
        aug = pitch_shift(aug, sr)
    else:
        aug = random_crop_pad(aug, sr)
        aug = add_pink_noise(aug)
        aug = volume_scale(aug)
    
    # Normalize to prevent clipping
    max_val = np.max(np.abs(aug)) + 1e-8
    if max_val > 1.0:
        aug = aug / max_val * 0.95
    
    return aug


# ── Main generator ────────────────────────────────────────────────────────

def generate(
    dataset_path: str = AUDIO_DATASET,
    target_min: int = TARGET_MIN_SAMPLES,
    sr: int = TARGET_SR,
):
    print("\n" + "=" * 60)
    print("   SYNTHETIC AUDIO DATA GENERATOR")
    print("=" * 60)

    for label in LABELS:
        folder = os.path.join(dataset_path, label)
        if not os.path.exists(folder):
            continue

        # Count existing real files (WAV + MP3)
        existing = list(Path(folder).glob("*.wav")) + list(Path(folder).glob("*.mp3"))
        real_count = len([f for f in existing if not f.stem.startswith("synth_")])
        total_count = len(existing)

        if real_count >= MINORITY_THRESHOLD:
            print(f"✓ {label:<25} {real_count} real samples — skipping (above threshold)")
            continue

        needed = max(0, target_min - total_count)
        if needed == 0:
            print(f"✓ {label:<25} {total_count} samples — already at target")
            continue

        print(f"\n🔧 {label:<25} {real_count} real samples → generating {needed} synthetic...")

        # Load all real audio files
        real_audio = []
        for fpath in existing:
            if fpath.stem.startswith("synth_"):
                continue
            try:
                audio, _ = librosa.load(str(fpath), sr=sr)
                real_audio.append({"audio": audio, "name": fpath.stem})
            except Exception as e:
                print(f"  ⚠ Could not load {fpath.name}: {e}")

        if not real_audio:
            print(f"  ⚠ No loadable audio files — skipping")
            continue

        generated = 0
        variant = 0

        # Phase 1: Single-sample augmentations
        while generated < needed:
            for sample in real_audio:
                if generated >= needed:
                    break

                aug = create_augmented_sample(sample["audio"], sr, variant)
                out_name = f"synth_{sample['name']}_v{variant:03d}.wav"
                out_path = os.path.join(folder, out_name)

                sf.write(out_path, aug, sr)
                generated += 1
                variant += 1

        # Phase 2: Mix pairs from the same class (if we still need more)
        if generated < needed and len(real_audio) >= 2:
            pairs = list(combinations(range(len(real_audio)), 2))
            np.random.shuffle(pairs)
            for i, j in pairs:
                if generated >= needed:
                    break
                mixed = mix_samples(real_audio[i]["audio"], real_audio[j]["audio"])
                # Apply additional augmentation to the mix
                mixed = create_augmented_sample(mixed, sr, variant)
                out_name = f"synth_mix_{real_audio[i]['name']}_{real_audio[j]['name']}_v{variant:03d}.wav"
                out_path = os.path.join(folder, out_name)
                sf.write(out_path, mixed, sr)
                generated += 1
                variant += 1

        print(f"  ✓ Generated {generated} synthetic samples for {label}")

    # Print final distribution
    print("\n" + "=" * 60)
    print("  FINAL AUDIO DATASET DISTRIBUTION")
    print("=" * 60)
    for label in LABELS:
        folder = os.path.join(dataset_path, label)
        if not os.path.exists(folder):
            continue
        wav_count = len(list(Path(folder).glob("*.wav")))
        mp3_count = len(list(Path(folder).glob("*.mp3")))
        synth_count = len(list(Path(folder).glob("synth_*.wav")))
        real_count = wav_count + mp3_count - synth_count
        print(f"  {label:<25} {real_count:>5} real + {synth_count:>5} synthetic = {wav_count + mp3_count:>5} total")

    print("\n✅ Synthetic data generation complete!")


if __name__ == "__main__":
    generate()
