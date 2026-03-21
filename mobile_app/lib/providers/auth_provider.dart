import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool isLoading = false;
  String? errorMessage;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.length >= 6) {
      _user = UserModel(
        id: '1',
        name: email.split('@')[0],
        email: email,
        createdAt: DateTime.now(),
      );
      isLoading = false;
      notifyListeners();
      return true;
    }

    errorMessage = 'Invalid email or password';
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signup(
    String name,
    String email,
    String password,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      _user = UserModel(
        id: '1',
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      isLoading = false;
      notifyListeners();
      return true;
    }

    errorMessage = 'Please fill all fields correctly';
    isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}