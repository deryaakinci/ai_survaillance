import os
import shutil
import cv2
import yaml
import torch
import numpy as np
from pathlib import Path
from ultralytics import YOLO


LABELS = [
    "normal",
    "weapon_detected",
    "explosion",
    "car_crash",
    "violence",
    "robbery",
    "person_down",
    "intrusion_detected",
    # NOTE: suspicious_package is handled by fusion engine's abandoned-object
    # tracking logic (COCO bag/suitcase detection + stationary-time + owner-distance).
]
LABEL_TO_IDX = {label: idx for idx, label in enumerate(LABELS)}


def get_device() -> str:
    if torch.backends.mps.is_available():
        return "mps"
    elif torch.cuda.is_available():
        return "cuda"
    return "cpu"


IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".bmp", ".webp"}


def prepare_yolo_dataset(
    source_path="simulation/datasets/video",
    image_path="simulation/datasets/image",
    output_path="ai_models/visual/yolo_dataset",
):
    print("\nPreparing YOLO dataset...")
    print("-" * 40)

    # ── Clean stale data from previous runs ────────────────────────
    if os.path.exists(output_path):
        print("Removing stale dataset from previous training run...")
        shutil.rmtree(output_path)

    for split in ["train", "val"]:
        os.makedirs(f"{output_path}/images/{split}", exist_ok=True)
        os.makedirs(f"{output_path}/labels/{split}", exist_ok=True)

    all_frames = []

    # ── Video frames ───────────────────────────────────────────────
    print("\nExtracting frames from videos...")
    class_videos = {}
    for label in LABELS:
        folder = os.path.join(source_path, label)
        if os.path.exists(folder):
            videos = []
            for ext in ["*.mp4", "*.avi", "*.mov"]:
                videos.extend(list(Path(folder).glob(ext)))
            if videos:
                class_videos[label] = videos

    if class_videos:
        max_videos = max(len(v) for v in class_videos.values())
        target_frames_per_class = max_videos * 5

        print(f"Targeting ~{target_frames_per_class} frames per video class")
        print("-" * 40)

        for label in LABELS:
            if label not in class_videos:
                continue

            video_files = class_videos[label]
            label_idx = LABEL_TO_IDX[label]
            frame_count = 0
            frames_per_video = max(1, int(np.ceil(target_frames_per_class / len(video_files))))

            for video_path in video_files:
                cap = cv2.VideoCapture(str(video_path))
                total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
                if total_frames <= 0:
                    cap.release()
                    continue

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
                        "source": "video",
                    })
                    frame_count += 1

                cap.release()

            print(f"✓ {label:<25} {frame_count} frames (from {len(video_files)} videos)")
    else:
        print("No video files found — using images only")

    # ── Static images (DISABLED) ────────────────────────────────────
    # Roboflow-exported images have a different visual domain than
    # surveillance video frames and corrupt the model when mixed in.
    # To re-enable, uncomment the block below.
    # print("\nCollecting static images...")
    # print("-" * 40)
    # image_count_total = 0
    # for label in LABELS:
    #     folder = os.path.join(image_path, label)
    #     if not os.path.exists(folder):
    #         continue
    #     images = [p for p in Path(folder).iterdir() if p.suffix.lower() in IMAGE_EXTENSIONS]
    #     if not images:
    #         continue
    #     label_idx = LABEL_TO_IDX[label]
    #     for img_path in images:
    #         all_frames.append({
    #             "img_path": str(img_path),
    #             "name": f"{label}_{img_path.stem}",
    #             "label_idx": label_idx,
    #             "label": label,
    #             "source": "image",
    #         })
    #     print(f"✓ {label:<25} {len(images)} images")
    #     image_count_total += len(images)
    # if image_count_total == 0:
    #     print("No static images found")

    if len(all_frames) == 0:
        print("No training data found!")
        return None

    # ── Class distribution summary ─────────────────────────────────
    print(f"\nTotal samples: {len(all_frames)}")
    print("Class distribution:")
    label_counts = {}
    for item in all_frames:
        label_counts[item["label"]] = label_counts.get(item["label"], 0) + 1
    for label in LABELS:
        if label in label_counts:
            print(f"  {label:<25} {label_counts[label]:>5}")

    np.random.shuffle(all_frames)
    split_idx = int(len(all_frames) * 0.8)
    train_frames = all_frames[:split_idx]
    val_frames = all_frames[split_idx:]

    print(f"\nTrain : {len(train_frames)}  |  Val : {len(val_frames)}")

    for split, frames in [("train", train_frames), ("val", val_frames)]:
        for item in frames:
            dst_img = f"{output_path}/images/{split}/{item['name']}.jpg"
            dst_lbl = f"{output_path}/labels/{split}/{item['name']}.txt"

            if item["source"] == "video":
                cv2.imwrite(dst_img, item["frame"])
            else:
                img = cv2.imread(item["img_path"])
                if img is not None:
                    cv2.imwrite(dst_img, img)

            with open(dst_lbl, "w") as f:
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
    image_path="simulation/datasets/image",
    output_path="ai_models/visual/yolo_dataset",
    save_path="ai_models/visual/saved_model",
    epochs=30,
    imgsz=640,
    batch=8,
):
    print("\n" + "=" * 55)
    print("   YOLOV8 FINE-TUNING FOR SURVEILLANCE")
    print("=" * 55)

    yaml_path = prepare_yolo_dataset(source_path, image_path, output_path)
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
    image_path="simulation/datasets/image",
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
        frame = None

        # Try video first
        video_folder = os.path.join(source_path, label)
        if os.path.exists(video_folder):
            video_files = list(Path(video_folder).glob("*.mp4"))
            if video_files:
                cap = cv2.VideoCapture(str(video_files[0]))
                ret, frame = cap.read()
                cap.release()
                if not ret:
                    frame = None

        # Fall back to image
        if frame is None:
            img_folder = os.path.join(image_path, label)
            if os.path.exists(img_folder):
                imgs = [p for p in Path(img_folder).iterdir() if p.suffix.lower() in IMAGE_EXTENSIONS]
                if imgs:
                    frame = cv2.imread(str(imgs[0]))

        if frame is None:
            continue

        results = model(frame, verbose=False)
        if results and results[0].boxes:
            pred_idx = int(results[0].boxes.cls[0])
            predicted = LABELS[pred_idx] if pred_idx < len(LABELS) else "unknown"
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