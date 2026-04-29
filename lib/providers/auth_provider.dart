import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isAuthenticated = false;
  String _role = 'member';
  int? _userId;
  String _name = '';

  bool get isAuthenticated => _isAuthenticated;
  String get role => _role;
  int? get userId => _userId;
  String get name => _name;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && !JwtDecoder.isExpired(token)) {
      final decodedToken = JwtDecoder.decode(token);
      _isAuthenticated = true;
      _role = decodedToken['role'] ?? 'member';
      _userId = decodedToken['id'];
      _name = prefs.getString('user_name') ?? '';
    } else {
      _isAuthenticated = false;
      prefs.remove('token');
    }
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'];
        final userName = data['user']?['name'] ?? '';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user_name', userName);
        await _loadUser();
        return null; // success
      }
      return data['message'] ?? 'Login failed';
    } catch (e) {
      return 'Connection error: ${e.toString()}';
    }
  }

  Future<String?> register(String name, String email, String password) async {
    try {
      final response = await _apiService.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return null; // success
      }
      return data['message'] ?? 'Registration failed';
    } catch (e) {
      return 'Connection error: ${e.toString()}';
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_name');
    _isAuthenticated = false;
    _role = 'member';
    _userId = null;
    _name = '';
    notifyListeners();
  }
  Future<void> updateName(String newName) async {
    _name = newName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newName);
    notifyListeners();
  }
}
