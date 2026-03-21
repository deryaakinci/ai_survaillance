class AlertModel {
  final String id;
  final String audioLabel;
  final String visualLabel;
  final String zone;
  final String severity;
  final DateTime timestamp;
  final String? snapshotUrl;
  final String? audioClipUrl;

  AlertModel({
    required this.id,
    required this.audioLabel,
    required this.visualLabel,
    required this.zone,
    required this.severity,
    required this.timestamp,
    this.snapshotUrl,
    this.audioClipUrl,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
        id: json['id'],
        audioLabel: json['audio_label'],
        visualLabel: json['visual_label'],
        zone: json['zone'] ?? 'Zone 1',
        severity: json['severity'] ?? 'medium',
        timestamp: DateTime.parse(json['timestamp']),
        snapshotUrl: json['snapshot_url'],
        audioClipUrl: json['audio_clip_url'],
      );
}