import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/secure_storage_service.dart';

String _dioErrorMessage(DioException e) {
  final data = e.response?.data;
  if (data is Map) {
    final d = data['detail'];
    if (d is String) return d;
    if (d is List && d.isNotEmpty) {
      final first = d.first;
      if (first is Map && first['msg'] != null) {
        return '${first['msg']}';
      }
      return first.toString();
    }
  }
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Connection timed out. Is the server running?';
    case DioExceptionType.connectionError:
      return 'Cannot reach server. Check API address and network.';
    default:
      break;
  }
  return 'Something went wrong. Please try again.';
}

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool isLoading = false;
  String? errorMessage;

  final ApiService _api = ApiService();
  final SecureStorageService _storage = SecureStorageService();

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> tryAutoLogin() async {
    final loggedIn = await _storage.isLoggedIn();
    if (loggedIn) {
      final userId = await _storage.getUserId();
      final userName = await _storage.getUserName();
      final userEmail = await _storage.getUserEmail();
      _user = UserModel(
        id: userId ?? '1',
        name: userName ?? 'User',
        email: userEmail ?? '',
        createdAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final normalizedEmail = email.trim().toLowerCase();
      if (normalizedEmail.isEmpty || password.isEmpty) {
        errorMessage = 'Enter email and password';
        isLoading = false;
        notifyListeners();
        return false;
      }

      final data = await _api.login(normalizedEmail, password);

      _user = UserModel(
        id: data['id'] ?? '1',
        name: data['name'] ?? normalizedEmail.split('@').first,
        email: normalizedEmail,
        createdAt: DateTime.now(),
      );

      isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      errorMessage = _dioErrorMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      errorMessage = 'Login failed. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(
    String name,
    String email,
    String password,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final normalizedEmail = email.trim().toLowerCase();
      if (name.trim().isEmpty ||
          normalizedEmail.isEmpty ||
          password.isEmpty) {
        errorMessage = 'Please fill all fields';
        isLoading = false;
        notifyListeners();
        return false;
      }

      final data = await _api.signup(name.trim(), normalizedEmail, password);

      _user = UserModel(
        id: data['id'] ?? '1',
        name: name.trim(),
        email: normalizedEmail,
        createdAt: DateTime.now(),
      );

      isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      errorMessage = _dioErrorMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      errorMessage = 'Signup failed. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile(String name) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (name.trim().isEmpty) {
        errorMessage = 'Name cannot be empty';
        isLoading = false;
        notifyListeners();
        return false;
      }

      await _api.updateProfile(name.trim());
      
      if (_user != null) {
        _user = UserModel(
          id: _user!.id,
          name: name.trim(),
          email: _user!.email,
          createdAt: _user!.createdAt,
        );
      }

      isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      errorMessage = _dioErrorMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      errorMessage = 'Failed to update profile. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (currentPassword.isEmpty || newPassword.isEmpty) {
        errorMessage = 'Passwords cannot be empty';
        isLoading = false;
        notifyListeners();
        return false;
      }
      if (newPassword.length < 6) {
        errorMessage = 'New password must be at least 6 characters';
        isLoading = false;
        notifyListeners();
        return false;
      }

      await _api.changePassword(currentPassword, newPassword);

      isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      errorMessage = _dioErrorMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      errorMessage = 'Failed to change password. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _api.logout();
    _user = null;
    notifyListeners();
  }
}