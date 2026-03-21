import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/secure_storage_service.dart';

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
      if (email.isEmpty || password.length < 6) {
        errorMessage = 'Invalid email or password';
        isLoading = false;
        notifyListeners();
        return false;
      }

      final data = await _api.login(email, password);

      _user = UserModel(
        id: data['id'] ?? '1',
        name: data['name'] ?? email.split('@')[0],
        email: email,
        createdAt: DateTime.now(),
      );

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
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
      if (name.isEmpty || email.isEmpty || password.length < 6) {
        errorMessage = 'Please fill all fields correctly';
        isLoading = false;
        notifyListeners();
        return false;
      }

      final data = await _api.signup(name, email, password);

      _user = UserModel(
        id: data['id'] ?? '1',
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Signup failed. Please try again.';
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