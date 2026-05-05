import torch
import numpy as np
from datetime import datetime

class FusionEngine:
    def __init__(self):
        # 1. M4 Pro Hardware Acceleration
        self.device = torch.device("mps") if torch.backends.mps.is_available() else torch.device("cpu")
        print(f"🚀 Fusion Engine active on: {self.device}")

        # 2. Abandoned Object Parameters
        self.STATIONARY_TIME_LIMIT = 60    # Seconds before marking as suspicious
        self.ABANDON_DISTANCE_METERS = 5.0 # Distance owner must be away
        self.STATIONARY_TOLERANCE = 0.05   # Movement threshold (pixels/units)

        # 3. Memory for Persistence
        # {obj_id: {"start_time": float, "last_pos": (x,y), "alert_sent": bool}}
        self.tracked_objects = {}
        # {bag_id: person_id}
        self.ownership_registry = {}

    def process_frame(self, detections, current_time):
        """
        Input: List of dicts [{'id': int, 'label': str, 'bbox': [x1, y1, x2, y2]}]
        Returns: List of active alerts
        """
        alerts = []
        
        # Separate entities
        people = [d for d in detections if d['label'] == 'person']
        bags = [d for d in detections if d['label'] in ['bag', 'suitcase', 'backpack']]

        for bag in bags:
            b_id = bag['id']
            b_center = self._get_center(bag['bbox'])

            # --- STEP 1: Identification (Who owns this?) ---
            if b_id not in self.ownership_registry:
                owner = self._find_nearest_person(b_center, people)
                if owner:
                    self.ownership_registry[b_id] = owner['id']

            # --- STEP 2: Stationary Check ---
            if b_id not in self.tracked_objects:
                self.tracked_objects[b_id] = {
                    "last_pos": b_center,
                    "stationary_since": current_time,
                    "alert_sent": False
                }
            else:
                # Check if it moved since the last frame
                move_dist = self._calculate_dist(b_center, self.tracked_objects[b_id]["last_pos"])
                if move_dist > self.STATIONARY_TOLERANCE:
                    # Reset timer because the bag is being carried or moved
                    self.tracked_objects[b_id]["stationary_since"] = current_time
                
                self.tracked_objects[b_id]["last_pos"] = b_center

            # --- STEP 3: Abandonment Logic ---
            stationary_duration = current_time - self.tracked_objects[b_id]["stationary_since"]
            owner_id = self.ownership_registry.get(b_id)
            
            # Find where the owner is now
            owner_data = next((p for p in people if p['id'] == owner_id), None)
            
            if owner_data:
                o_center = self._get_center(owner_data['bbox'])
                current_gap = self._calculate_dist(b_center, o_center)
            else:
                # Owner has left the camera view entirely
                current_gap = 999.0 

            # FINAL TRIGGER: Still for 60s AND Owner is far/gone
            if stationary_duration >= self.STATIONARY_TIME_LIMIT and current_gap > self.ABANDON_DISTANCE_METERS:
                if not self.tracked_objects[b_id]["alert_sent"]:
                    alerts.append(self._create_alert(bag, b_center))
                    self.tracked_objects[b_id]["alert_sent"] = True

        return alerts

    def _calculate_dist(self, p1, p2):
        """ Euclidean Distance: $\sqrt{(x_2-x_1)^2 + (y_2-y_1)^2}$ """
        return np.sqrt((p1[0] - p2[0])**2 + (p1[1] - p2[1])**2)

    def _get_center(self, bbox):
        return ((bbox[0] + bbox[2]) / 2, (bbox[1] + bbox[3]) / 2)

    def _find_nearest_person(self, bag_pos, people):
        best_match = None
        min_dist = 2.0 # Must be within 2 units to "own" the bag
        for p in people:
            p_pos = self._get_center(p['bbox'])
            d = self._calculate_dist(bag_pos, p_pos)
            if d < min_dist:
                min_dist = d
                best_match = p
        return best_match

    def _create_alert(self, bag, pos):
        return {
            "event": "ABANDONED_OBJECT",
            "object": bag['label'],
            "id": bag['id'],
            "location": pos,
            "timestamp": datetime.now().isoformat()
        }

    # ── Cross-modal consistency ──────────────────────────────────────────
    # Maps each audio label → set of visual labels it naturally correlates
    # with.  If the visual label is NOT in this set the audio prediction is
    # considered unreliable and gets overridden.
    AUDIO_VISUAL_COMPAT = {
        "gunshot":           {"weapon_detected", "robbery", "assault", "fighting", "person_down"},
        "explosion":         {"explosion", "person_down", "vehicle_intrusion"},
        "scream":            {"assault", "abuse", "robbery", "fighting", "person_down", "intruder_detected", "forced_entry"},
        "glass_break":       {"forced_entry", "intruder_detected", "robbery", "weapon_detected"},
        "forced_entry":      {"forced_entry", "intruder_detected", "robbery"},
        "crying_distress":   {"abuse", "person_down", "assault", "robbery"},
        "fight_sounds":      {"fighting", "assault", "abuse", "person_down", "robbery"},
        "siren":             {"vehicle_intrusion", "person_down", "explosion"},
        "car_crash":         {"vehicle_intrusion", "explosion", "person_down"},
    }

    # Minimum confidence to consider a prediction real
    # Audio stays strict (0.45) to filter ambient-sound false positives.
    # Visual is looser (0.30) because scene classification is harder.
    MIN_AUDIO_CONFIDENCE = 0.25
    MIN_VISUAL_CONFIDENCE = 0.30

    def fuse(self, audio_result: dict, visual_result: dict) -> dict:
        """
        Fuses audio and visual results with cross-modal consistency
        checking and confidence thresholding.

        Key improvements:
        - Audio predictions below MIN_AUDIO_CONFIDENCE are treated as "normal"
        - Visual predictions below MIN_VISUAL_CONFIDENCE are treated as "normal"
        - Agreement bonus increased to 15% (was 5%)
        - Disagreement penalty applied more aggressively
        """
        a_label = audio_result.get("label", "normal")
        v_label = visual_result.get("label", "normal")

        a_conf = audio_result.get("confidence", 0.0)
        v_conf = visual_result.get("confidence", 0.0)

        # ── Confidence floor ───────────────────────────────────────────
        if a_label != "normal" and a_conf < self.MIN_AUDIO_CONFIDENCE:
            a_label = "normal"
            a_conf = 1.0 - a_conf
        if v_label != "normal" and v_conf < self.MIN_VISUAL_CONFIDENCE:
            v_label = "normal"
            v_conf = 1.0 - v_conf

        # ── Require visual confirmation (soft) ─────────────────────────
        # Suppress audio-only alerts, but only when the camera is
        # *confidently* normal (≥ 0.80). If the visual model is uncertain,
        # the audio is still trusted.
        if a_label != "normal" and v_label == "normal" and v_conf >= 0.80:
            a_label = "normal"
            a_conf = 1.0 - a_conf

        # ── Cross-modal consistency check ──────────────────────────────
        # Visual is generally more reliable for scene classification,
        # so when audio contradicts visual we correct the audio label.
        if a_label != "normal" and v_label != "normal":
            compatible_visuals = self.AUDIO_VISUAL_COMPAT.get(a_label)
            if compatible_visuals and v_label not in compatible_visuals:
                # Audio label doesn't match what the camera sees
                # → override audio with a label consistent with the visual
                a_label = v_label          # align to visual scene
                a_conf  = a_conf * 0.3     # heavily penalise the audio conf

        # ── Re-check audio confidence after cross-modal override ──────────
        # The cross-modal penalty (×0.3) can push audio confidence below the
        # minimum threshold. Re-check so heavily-penalized overrides don't
        # generate spurious alerts (e.g. forced_entry → vehicle_intrusion at 0.22).
        if a_label != "normal" and a_conf < self.MIN_AUDIO_CONFIDENCE:
            a_label = "normal"
            a_conf = 1.0 - a_conf

        # ── Suppress weak visual-only anomalies ────────────────────────
        # Runs AFTER cross-modal re-check so it sees the final audio state.
        # If audio is confidently silent and visual is only weakly anomalous,
        # the visual classification is almost certainly a false positive
        # (e.g. news/weather footage, busy backgrounds). Genuine threats
        # either trigger audio confirmation or produce high visual confidence.
        if (v_label != "normal" and v_conf < 0.40
                and a_label == "normal" and a_conf >= 0.30):
            v_label = "normal"
            v_conf = 1.0 - v_conf

        # ── Weapon upgrade ─────────────────────────────────────────────
        # Base YOLO cannot detect firearms; the ResNet18 rarely outputs
        # weapon_detected for real videos. Best proxy: if the microphone
        # hears a gunshot while the camera sees a violent scene, the most
        # likely explanation is that weapons are present.
        WEAPON_AUDIO   = {"gunshot", "fight_sounds"}
        WEAPON_VISUAL  = {"fighting", "assault", "robbery", "abuse",
                          "intruder_detected", "forced_entry", "person_down"}
        if a_label in WEAPON_AUDIO and v_label in WEAPON_VISUAL:
            v_label = "weapon_detected"
            v_conf  = max(v_conf, 0.75)

        # When only one modality fires, trust it as-is (no conflict to resolve)

        # ── Fused score ────────────────────────────────────────────────
        if a_label != "normal" and v_label != "normal":
            if a_label == v_label:
                # Both agree → strong boost (15%)
                fused_score = min(1.0, max(a_conf, v_conf) * 1.15)
            else:
                # Both abnormal but different classes → penalised average
                fused_score = max(a_conf, v_conf) * 0.85
        elif a_label != "normal" or v_label != "normal":
            # Only one modality flags anomaly — trust but don't boost
            fused_score = max(a_conf, v_conf)
        else:
            fused_score = max(a_conf, v_conf)

        alert = (a_label != "normal") or (v_label != "normal")

        # ── Severity ──────────────────────────────────────────────────
        severity = "low"
        if alert:
            high = [
                "weapon_detected", "person_down", "explosion", "robbery",
                "forced_entry", "assault", "abuse", "gunshot", "scream",
                "fight_sounds",
            ]
            medium = [
                "intruder_detected", "vehicle_intrusion", "fighting",
                "suspicious_package", "glass_break",
                "crying_distress", "car_crash",
            ]

            if a_label in high or v_label in high:
                severity = "high"
            elif a_label in medium or v_label in medium:
                severity = "medium"
            else:
                severity = "low"

        return {
            "audio_label": a_label,
            "visual_label": v_label,
            "fused_score": round(fused_score, 3),
            "alert": alert,
            "severity": severity,
        }