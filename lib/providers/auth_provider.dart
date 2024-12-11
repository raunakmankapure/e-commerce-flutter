import 'package:flutter/foundation.dart';
import 'package:flutter_ecommerce/models/user.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoggedIn = false;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  User? get user => _user;
  String? get token => _token;

  Future<bool> login(String email, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (email.isNotEmpty && password.isNotEmpty) {
        _user = User(
          id: '1',
          email: email,
          name: 'Test User',
        );
        _isLoggedIn = true;
        _token = 'dummy_token';

        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', json.encode(_user?.toJson()));
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('token', _token!);

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        _user = User(
          id: '1',
          email: email,
          name: name,
        );
        _isLoggedIn = true;
        _token = 'dummy_token';

        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', json.encode(_user?.toJson()));
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('token', _token!);

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _user = null;
    _isLoggedIn = false;
    _token = null;

    // Clear local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (_isLoggedIn) {
      final userJson = prefs.getString('user');
      if (userJson != null) {
        _user = User.fromJson(json.decode(userJson));
        _token = prefs.getString('token');
      }
    }
    notifyListeners();
  }
}
