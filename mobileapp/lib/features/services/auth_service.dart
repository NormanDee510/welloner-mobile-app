import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobileapp/app/routes.dart';

class AuthService {
  final String apiBaseUrl; // e.g., https://localhost:44399/
  final http.Client httpClient;
  final BehaviorSubject<Map<String, dynamic>?> _userSubject;
  ValueStream<Map<String, dynamic>?> get user$ => _userSubject.stream;

  // AuthService({
  //   required this.apiBaseUrl,
  //   required this.httpClient,
  // }) : _userSubject = BehaviorSubject<Map<String, dynamic>?>.seeded(_getStoredUser() as Map<String, dynamic>?);

  // // Retrieve stored user from SharedPreferences
  // static Future<Map<String, dynamic>?>? _getStoredUser() {
  //   try {
  //     final prefs = SharedPreferences.getInstance().asStream().first;
  //     final userJson = prefs.then((p) => p.getString('user'));
  //     return userJson.then((json) => json != null ? jsonDecode(json) as Map<String, dynamic> : null);
  //   } catch (e) {
  //     print('Error retrieving stored user: $e');
  //     return null;
  //   }
  // }
 AuthService({
    required this.apiBaseUrl,
    required this.httpClient,
  }) : _userSubject = BehaviorSubject<Map<String, dynamic>?>.seeded(null) {
    _loadStoredUser(); // Load user asynchronously during initialization
  }

  // Load stored user from SharedPreferences
  Future<void> _loadStoredUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        final user = jsonDecode(userJson) as Map<String, dynamic>;
        _userSubject.add(user);
      }
    } catch (e) {
      print('Error loading stored user: $e');
    }
  }
  // Set user in BehaviorSubject and SharedPreferences
  void setUser(Map<String, dynamic>? user) {
    _userSubject.add(user);
    _setItem('user', user);
  }

  // Logout: Clear storage, reset user, and navigate to login
  Future<void> logout(BuildContext context) async {
    await _clearToken();
    _userSubject.add(null);
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  // Login: Make HTTP request and store user data
  Future<Map<String, dynamic>?> login(String userName, String password) async {
    final loginData = {
      'userName': userName.trim(),
      'password': password.trim(),
    };

    try {
      final response = await httpClient.post(
        Uri.parse('${apiBaseUrl}api/Auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(loginData),
      );
      print('Login request sent to: ${apiBaseUrl}api/Auth/login');
      print('Request payload: ${jsonEncode(loginData)}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        if (responseData['accessToken'] != null) {
          final user = {
            'id': responseData['id'],
            'userName': responseData['userName'],
            'roleId': responseData['roleId'],
            'claimStatusId': responseData['claimStatusId'],
            'accessToken': responseData['accessToken'],
          };
          setUser(user);
          await _setItem('token', responseData['accessToken']);
          return user;
        } else {
          throw Exception('No access token in response');
        }
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(errorData['Message'] ?? 'Login failed: ${response.statusCode}');
      }
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // Handle errors
  void _handleError(dynamic error) {
    print('Error: $error');
    throw Exception('Login failed: $error');
  }

  // Get token from SharedPreferences
  Future<String> getToken() async {
    final token = await _getItem<String>('token');
    return token ?? '';
  }

  // Clear token and user data
  Future<void> _clearToken() async {
    await _removeItem('jwt');
    await _removeItem('token');
    await _removeItem('user');
  }

  // Get item from SharedPreferences
  Future<T?> _getItem<T>(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(key);
      if (key == 'token' || key == 'jwt') {
        return data as T?;
      }
      return data != null ? jsonDecode(data) as T? : null;
    } catch (e) {
      print('Error parsing JSON for key "$key": $e');
      return null;
    }
  }

  // Set item in SharedPreferences
  Future<void> _setItem(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data is String) {
      await prefs.setString(key, data);
    } else {
      await prefs.setString(key, jsonEncode(data));
    }
  }

  // Remove item from SharedPreferences
  Future<void> _removeItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Clear all SharedPreferences
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Get current user
  Map<String, dynamic>? getCurrentUser() {
    print('Current user: ${_userSubject.value}');
    return _userSubject.value;
  }
}
