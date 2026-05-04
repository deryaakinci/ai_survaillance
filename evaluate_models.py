import sys
import os

# Add the root project directory to the python path
project_root = os.path.dirname(os.path.abspath(__file__))
sys.path.append(project_root)

def main():
    print("🚀 Running AI Model Evaluations...\n")
    
    # Evaluate Audio Model
    try:
        from ai_models.audio.train_audio_model import evaluate as evaluate_audio
        print("=" * 60)
        print("🔊 AUDIO MODEL EVALUATION")
        print("=" * 60)
        evaluate_audio()
    except Exception as e:
        print(f"Error evaluating audio model: {e}")

    # Evaluate Visual Model (ResNet18 Classifier)
    try:
        from ai_models.visual.train_visual_classifier import evaluate as evaluate_visual
        print("\n" + "=" * 60)
        print("👁️ VISUAL MODEL (ResNet18 Classifier) EVALUATION")
        print("=" * 60)
        evaluate_visual()
    except Exception as e:
        print(f"Error evaluating visual model: {e}")

if __name__ == "__main__":
    main()
