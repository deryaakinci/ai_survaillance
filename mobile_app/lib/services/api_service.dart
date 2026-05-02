import 'package:dio/dio.dart';
import '../models/alert_model.dart';
import 'secure_storage_service.dart';

class ApiService {
  // TODO: Update baseUrl for your environment:
  //   Android emulator  → 'http://10.0.2.2:8000'
  //   iOS simulator     → 'http://127.0.0.1:8000'
  //   Real device       → 'http://<your-machine-local-IP>:8000'
  // Currently configured for iOS simulator + local backend.
  static const String baseUrl = 'http://127.0.0.1:8000';

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

  Future<void> updateProfile(String name) async {
    await _dio.put(
      '/auth/profile',
      data: {'name': name},
    );
    await _storage.saveUserName(name);
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    await _dio.put(
      '/auth/password',
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );
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
      return [];
    }
  }

  Future<Map<String, dynamic>> getStats({int days = 7}) async {
    try {
      final response = await _dio.get(
        '/stats',
        queryParameters: {'days': days},
      );
      final data = Map<String, dynamic>.from(response.data);
      // Ensure nested types are properly cast
      if (data['alert_types'] != null) {
        data['alert_types'] = Map<String, dynamic>.from(data['alert_types']);
      }
      if (data['hourly'] != null) {
        data['hourly'] = List<int>.from(
          (data['hourly'] as List).map((e) => (e as num).toInt()),
        );
      }
      return data;
    } catch (e) {
      return {
        'total': 0,
        'today': 0,
        'accuracy': null,
        'audio_accuracy': null,
        'visual_accuracy': null,
        'total_events': 0,
        'high': 0,
        'medium': 0,
        'low': 0,
        'days': days,
        'alert_types': <String, dynamic>{},
        'hourly': List<int>.filled(24, 0),
      };
    }
  }
}