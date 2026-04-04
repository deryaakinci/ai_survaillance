import 'dart:async';
import 'package:flutter/material.dart';
import '../models/alert_model.dart';
import '../services/api_service.dart';

class AlertProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<AlertModel> alerts = [];
  bool isLoading = false;
  int selectedDays = 7;
  bool audioOnline = true;
  bool visualOnline = true;
  Timer? _pollingTimer;

  // ── Analytics data from backend ──────────────────────────────────
  int totalAlerts = 0;
  int alertsToday = 0;
  double? accuracy;          // null = no AI data yet
  double? audioAccuracy;
  double? visualAccuracy;
  int totalEvents = 0;
  int highCount = 0;
  int mediumCount = 0;
  int lowCount = 0;
  Map<String, int> alertTypes = {};
  List<int> hourly = List<int>.filled(24, 0);

  Future<void> loadAlerts() async {
    isLoading = true;
    notifyListeners();
    final fetched = await _api.getAlerts(days: selectedDays);
    alerts = fetched;
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadAnalytics() async {
    final data = await _api.getStats(days: selectedDays);
    totalAlerts = (data['total'] as num?)?.toInt() ?? 0;
    alertsToday = (data['today'] as num?)?.toInt() ?? 0;
    accuracy = (data['accuracy'] as num?)?.toDouble();  // null if no AI data
    audioAccuracy = (data['audio_accuracy'] as num?)?.toDouble();
    visualAccuracy = (data['visual_accuracy'] as num?)?.toDouble();
    totalEvents = (data['total_events'] as num?)?.toInt() ?? 0;
    highCount = (data['high'] as num?)?.toInt() ?? 0;
    mediumCount = (data['medium'] as num?)?.toInt() ?? 0;
    lowCount = (data['low'] as num?)?.toInt() ?? 0;

    if (data['alert_types'] != null) {
      final raw = data['alert_types'] as Map<String, dynamic>;
      alertTypes = raw.map((k, v) => MapEntry(k, (v as num).toInt()));
    } else {
      alertTypes = {};
    }

    if (data['hourly'] != null) {
      hourly = List<int>.from(
        (data['hourly'] as List).map((e) => (e as num).toInt()),
      );
    } else {
      hourly = List<int>.filled(24, 0);
    }

    notifyListeners();
  }

  void startPolling() {
    loadAlerts();
    loadAnalytics();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 8),
      (_) {
        loadAlerts();
        loadAnalytics();
      },
    );
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> refreshNow() async {
    await Future.wait([loadAlerts(), loadAnalytics()]);
  }

  void setDays(int days) {
    selectedDays = days;
    loadAlerts();
    loadAnalytics();
  }

  void updateSensorStatus({
    required bool audio,
    required bool visual,
  }) {
    audioOnline = audio;
    visualOnline = visual;
    notifyListeners();
  }

  List<AlertModel> get todayAlerts {
    final now = DateTime.now();
    return alerts.where((a) =>
      a.timestamp.day == now.day &&
      a.timestamp.month == now.month &&
      a.timestamp.year == now.year,
    ).toList();
  }

  int countByType(String label) {
    // Use backend data if available, fall back to client-side count
    if (alertTypes.containsKey(label)) {
      return alertTypes[label] ?? 0;
    }
    return alerts
        .where((a) => a.audioLabel
            .toLowerCase()
            .contains(label.toLowerCase()))
        .length;
  }
}