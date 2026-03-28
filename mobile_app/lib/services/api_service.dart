import 'package:dio/dio.dart';
import '../models/alert_model.dart';
import 'secure_storage_service.dart';

class ApiService {
  // TODO: Update baseUrl for your environment:
  //   Android emulator  → 'http://10.0.2.2:8000'
  //   iOS simulator     → 'http://127.0.0.1:8000'
  //   Real device       → 'http://<your-machine-local-IP>:8000'
  static const String baseUrl = 'http://10.0.2.2:8000';

  final SecureStorageService _storage = SecureStorageService();
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _storage.clearAll();
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    final token = response.data['token'];
    if (token != null) {
      await _storage.saveToken(token);
      await _storage.saveUserId(response.data['id'] ?? '');
      await _storage.saveUserName(response.data['name'] ?? '');
      await _storage.saveUserEmail(email);
    }
    return response.data;
  }

  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
  ) async {
    final response = await _dio.post(
      '/auth/signup',
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    final token = response.data['token'];
    if (token != null) {
      await _storage.saveToken(token);
      await _storage.saveUserId(response.data['id'] ?? '');
      await _storage.saveUserName(name);
      await _storage.saveUserEmail(email);
    }
    return response.data;
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }

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
        '/stats',
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
        timestamp: DateTime.now().subtract(
          const Duration(minutes: 2),
        ),
      ),
      AlertModel(
        id: '2',
        audioLabel: 'Intruder alert',
        visualLabel: 'Person detected',
        zone: 'Zone 2',
        severity: 'medium',
        timestamp: DateTime.now().subtract(
          const Duration(minutes: 18),
        ),
      ),
      AlertModel(
        id: '3',
        audioLabel: 'Glass break',
        visualLabel: 'No person',
        zone: 'Zone 3',
        severity: 'low',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1),
        ),
      ),
      AlertModel(
        id: '4',
        audioLabel: 'Scream detected',
        visualLabel: 'Person detected',
        zone: 'Zone 1',
        severity: 'high',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 3),
        ),
      ),
      AlertModel(
        id: '5',
        audioLabel: 'Glass break',
        visualLabel: 'No person',
        zone: 'Zone 2',
        severity: 'low',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 5),
        ),
      ),
    ];
  }
}