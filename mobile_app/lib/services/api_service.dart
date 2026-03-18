import 'package:dio/dio.dart';
import '../models/alert_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:8000',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  Future<List<AlertModel>> getAlerts({int days = 7}) async {
    try {
      final response = await _dio.get(
        '/alerts',
        queryParameters: {'days': days},
      );
      return (response.data as List)
          .map((e) => AlertModel.fromJson(e))
          .toList();
    } catch (e) {
      return _mockAlerts();
    }
  }

  Future<Map<String, dynamic>> getStats({int days = 7}) async {
    try {
      final response = await _dio.get(
        '/alerts/stats',
        queryParameters: {'days': days},
      );
      return response.data;
    } catch (e) {
      return {'total': 12, 'accuracy': 98};
    }
  }

  List<AlertModel> _mockAlerts() {
    return [
      AlertModel(
        id: '1',
        audioLabel: 'Gunshot detected',
        visualLabel: 'Person detected',
        zone: 'Zone 1',
        severity: 'high',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      AlertModel(
        id: '2',
        audioLabel: 'Intruder alert',
        visualLabel: 'Person detected',
        zone: 'Zone 2',
        severity: 'medium',
        timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
      ),
      AlertModel(
        id: '3',
        audioLabel: 'Glass break',
        visualLabel: 'No person',
        zone: 'Zone 3',
        severity: 'low',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      AlertModel(
        id: '4',
        audioLabel: 'Scream detected',
        visualLabel: 'Person detected',
        zone: 'Zone 1',
        severity: 'high',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      AlertModel(
        id: '5',
        audioLabel: 'Glass break',
        visualLabel: 'No person',
        zone: 'Zone 2',
        severity: 'low',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }
}