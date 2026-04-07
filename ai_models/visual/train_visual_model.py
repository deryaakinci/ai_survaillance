import os
import cv2
import yaml
import torch
import numpy as np
from pathlib import Path
from ultralytics import YOLO


LABELS = [
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
]
LABEL_TO_IDX = {label: idx for idx, label in enumerate(LABELS)}


def get_device() -> str:
    if torch.backends.mps.is_available():
        return "mps"
    elif torch.cuda.is_available():
        return "cuda"
    return "cpu"


def prepare_yolo_dataset(
    source_path="simulation/datasets/video",
    output_path="ai_models/visual/yolo_dataset",
):
    print("\nPreparing YOLO dataset...")
    print("-" * 40)

    for split in ["train", "val"]:
        os.makedirs(f"{output_path}/images/{split}", exist_ok=True)
        os.makedirs(f"{output_path}/labels/{split}", exist_ok=True)

    all_frames = []

    print("\nCalculating class video distribution for balanced sampling...")
    class_videos = {}
    for label in LABELS:
        folder = os.path.join(source_path, label)
        if os.path.exists(folder):
            videos = []
            for ext in ["*.mp4", "*.avi", "*.mov"]:
                videos.extend(list(Path(folder).glob(ext)))
            if videos:
                class_videos[label] = videos

    if not class_videos:
        print("No video files found!")
        return None

    # Calculate target frames to balance classes
    # We aim for ~5 frames per video for the largest class, and scale up for minority classes
    max_videos = max(len(v) for v in class_videos.values())
    target_frames_per_class = max_videos * 5
    
    print(f"\nBalancing dataset: Targeting ~{target_frames_per_class} frames per class")
    print("-" * 40)

    for label in LABELS:
        if label not in class_videos:
            print(f"⚠ Skipping {label} — no video files")
            continue

        video_files = class_videos[label]
        label_idx = LABEL_TO_IDX[label]
        frame_count = 0
        
        # Calculate how many frames to extract per video to hit the target
        frames_per_video = max(1, int(np.ceil(target_frames_per_class / len(video_files))))

        for video_path in video_files:
            cap = cv2.VideoCapture(str(video_path))
            total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
            
            if total_frames <= 0:
                cap.release()
                continue
                
            # Extract balanced number of frames (don't exceed total frames in the video)
            num_to_extract = min(frames_per_video, total_frames)
            frame_indices = np.linspace(0, total_frames - 1, num_to_extract, dtype=int)

            for idx in frame_indices:
                cap.set(cv2.CAP_PROP_POS_FRAMES, idx)
                ret, frame = cap.read()
                if not ret:
                    continue

                frame_name = f"{label}_{video_path.stem}_frame{idx}"
                all_frames.append({
                    "frame": frame,
                    "name": frame_name,
                    "label_idx": label_idx,
                    "label": label,
                })
                frame_count += 1

            cap.release()

        print(f"✓ {label:<25} {frame_count} frames extracted (from {len(video_files)} videos)")

    print(f"\nTotal frames: {len(all_frames)}")
    
    # ── Class-weighted tracking to show distribution ──
    print(f"\nClass distribution (balanced frames):")
    label_counts = {}
    for item in all_frames:
        l = item['label']
        label_counts[l] = label_counts.get(l, 0) + 1
    for label in LABELS:
        if label in label_counts:
            print(f"  {label:<25} {label_counts[label]:>5} frames")

    if len(all_frames) == 0:
        print("No frames extracted! Add videos to dataset folders.")
        return None

    np.random.shuffle(all_frames)
    split_idx = int(len(all_frames) * 0.8)
    train_frames = all_frames[:split_idx]
    val_frames = all_frames[split_idx:]

    print(f"Train frames : {len(train_frames)}")
    print(f"Val frames   : {len(val_frames)}")

    for split, frames in [("train", train_frames), ("val", val_frames)]:
        for item in frames:
            img_path = f"{output_path}/images/{split}/{item['name']}.jpg"
            cv2.imwrite(img_path, item["frame"])

            label_path = f"{output_path}/labels/{split}/{item['name']}.txt"
            with open(label_path, "w") as f:
                f.write(f"{item['label_idx']} 0.5 0.5 1.0 1.0\n")

    yaml_content = {
        "path": os.path.abspath(output_path),
        "train": "images/train",
        "val": "images/val",
        "nc": len(LABELS),
        "names": LABELS,
    }

    yaml_path = f"{output_path}/data.yaml"
    with open(yaml_path, "w") as f:
        yaml.dump(yaml_content, f, default_flow_style=False)

    print(f"\n✓ YOLO dataset saved to {output_path}")
    return yaml_path


def train(
    source_path="simulation/datasets/video",
    output_path="ai_models/visual/yolo_dataset",
    save_path="ai_models/visual/saved_model",
    epochs=50,
    imgsz=640,
    batch=8,
):
    print("\n" + "=" * 55)
    print("   YOLOV8 FINE-TUNING FOR SURVEILLANCE")
    print("=" * 55)

    total_videos = 0
    for label in LABELS:
        folder = os.path.join(source_path, label)
        if os.path.exists(folder):
            for ext in ["*.mp4", "*.avi", "*.mov"]:
                total_videos += len(list(Path(folder).glob(ext)))

    if total_videos == 0:
        print("\nNo video files found!")
        print("Add videos to simulation/datasets/video/ folders first.")
        return

    print(f"\nFound {total_videos} video files across all classes")

    yaml_path = prepare_yolo_dataset(source_path, output_path)
    if yaml_path is None:
        return

    device = get_device()
    print(f"\nUsing device: {device}")
    print("\nLoading pretrained YOLOv8n...")
    model = YOLO("yolov8n.pt")

    print(f"\nFine-tuning for {epochs} epochs...")
    print("-" * 40)

    os.makedirs(save_path, exist_ok=True)

    results = model.train(
        data=yaml_path,
        epochs=epochs,
        imgsz=imgsz,
        batch=batch,
        name="surveillance_model",
        project=os.path.abspath(save_path),
        exist_ok=True,
        patience=10,
        save=True,
        plots=True,
        verbose=True,
        device=device,
    )

    print("\n" + "=" * 55)
    print("Fine-tuning complete!")
    print(f"Model saved to: {save_path}/surveillance_model/")
    print("=" * 55)

    return results


def evaluate(
    source_path="simulation/datasets/video",
    save_path="ai_models/visual/saved_model",
):
    model_path = f"{save_path}/surveillance_model/weights/best.pt"
    if not os.path.exists(model_path):
        print("No fine-tuned model found. Run training first.")
        return

    print("\nEvaluating fine-tuned model...")
    print("-" * 40)

    model = YOLO(model_path)
    correct = 0
    total = 0

    for label in LABELS:
        folder = os.path.join(source_path, label)
        if not os.path.exists(folder):
            continue

        video_files = list(Path(folder).glob("*.mp4"))
        if not video_files:
            continue

        cap = cv2.VideoCapture(str(video_files[0]))
        ret, frame = cap.read()
        cap.release()

        if not ret:
            continue

        results = model(frame, verbose=False)
        if results and results[0].boxes:
            pred_idx = int(results[0].boxes.cls[0])
            predicted = (
                LABELS[pred_idx] if pred_idx < len(LABELS) else "unknown"
            )
        else:
            predicted = "normal"

        is_correct = predicted == label
        correct += int(is_correct)
        total += 1
        symbol = "✓" if is_correct else "✗"
        print(f"{symbol} True: {label:<25} Predicted: {predicted}")

    if total > 0:
        accuracy = 100.0 * correct / total
        print("-" * 40)
        print(f"Accuracy: {accuracy:.1f}% ({correct}/{total})")


if __name__ == "__main__":
    train()
    evaluate()