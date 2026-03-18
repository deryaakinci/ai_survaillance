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

  Future<void> loadAlerts() async {
    isLoading = true;
    notifyListeners();
    alerts = await _api.getAlerts(days: selectedDays);
    isLoading = false;
    notifyListeners();
  }

  void setDays(int days) {
    selectedDays = days;
    loadAlerts();
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
    return alerts
        .where((a) => a.audioLabel.toLowerCase().contains(label.toLowerCase()))
        .length;
  }
}