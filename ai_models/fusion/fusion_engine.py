import torch
import numpy as np
import time
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

    def fuse(self, audio_result: dict, visual_result: dict) -> dict:
        """
        Fuses the results from the audio and visual models.
        Matches the expected output format for demo_video_runner.py and alert_logic.py.
        """
        a_label = audio_result.get("label", "normal")
        v_label = visual_result.get("label", "normal")
        
        a_conf = audio_result.get("confidence", 0.0)
        v_conf = visual_result.get("confidence", 0.0)
        
        # Simple rule: if either is abnormal, it's an alert
        alert = (a_label != "normal") or (v_label != "normal")
        
        fused_score = max(a_conf, v_conf)
        
        # Determine highest severity based on both labels
        severity = "low"
        if alert:
            high = [
                "weapon_detected", "person_down", "explosion", "robbery", 
                "forced_entry", "assault", "abuse", "gunshot", "scream", 
                "fight_sounds", "door_forced", "threatening_voice"
            ]
            medium = [
                "intruder_detected", "vehicle_intrusion", "fighting", 
                "suspicious_package", "glass_break", "break_in", 
                "crying_distress", "car_crash"
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
            "fused_score": fused_score,
            "alert": alert,
            "severity": severity
        }