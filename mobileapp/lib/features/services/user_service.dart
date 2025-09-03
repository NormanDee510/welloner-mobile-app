import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobileapp/features/models/user_details.dart';
import 'package:mobileapp/app/core/constants/environment.dart';

class UserDetailsService {
  final String apiBaseUrl;
  final http.Client httpClient;

  UserDetailsService({required this.apiBaseUrl, required this.httpClient});

  // Helper method to create headers
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Error handling
  http.Response _handleError(http.Response response) {
    if (response.statusCode >= 400 && response.statusCode < 500) {
      print('Client side error: ${response.body}');
      throw ClientException('Client error: ${response.statusCode}');
    } else if (response.statusCode >= 500) {
      print('Server side error: ${response.body}');
      throw ServerException('Server error: ${response.statusCode}');
    }
    return response;
  }

  // Login user
  Future<Map<String, dynamic>> loginUser(UserDetails user) async {
    try {
      final response = await httpClient.post(
        Uri.parse('${Environment.apiBaseUrl}/api/Auth/login'),
        headers: _getHeaders(),
        body: json.encode(user.toJson()),
      );

      _handleError(response);
      final data = json.decode(response.body);
      if (data is! Map<String, dynamic>) {
        throw ClientException('Unexpected response format');
      }
      return data;
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  // Get all users
  Future<List<UserDetails>> getAllUsers() async {
    try {
      final response = await httpClient.get(
        Uri.parse('${Environment.apiBaseUrl}/api/User'),
        headers: _getHeaders(),
      );

      _handleError(response);
      final data = json.decode(response.body);
      if (data is! List) {
        throw ClientException('Expected a list of users');
      }
      return data.map((json) => UserDetails.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Get users error: $e');
      rethrow;
    }
  }

  // Get user links
  Future<List<UserDetails>> getUserLinks() async {
    try {
      final response = await httpClient.get(
        Uri.parse('${Environment.apiBaseUrl}/api/User/LinkUser'),
        headers: _getHeaders(),
      );

      _handleError(response);
      final data = json.decode(response.body);
      if (data is! List) {
        throw ClientException('Expected a list of user links');
      }
      return data.map((json) => UserDetails.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Get user links error: $e');
      rethrow;
    }
  }

  // Register user
  Future<UserDetails> registerUser(UserDetails user) async {
    try {
      final response = await httpClient.post(
        Uri.parse('${Environment.apiBaseUrl}/api/Auth/register'),
        headers: _getHeaders(),
        body: json.encode(user.toJson()),
      );

      _handleError(response);
      final data = json.decode(response.body);
      if (data is! Map<String, dynamic>) {
        throw ClientException('Unexpected response format');
      }
      return UserDetails.fromJson(data);
    } catch (e) {
      print('Registration error from user service: $e');
      rethrow;
    }
  }
}

// Custom exception classes
class ClientException implements Exception {
  final String message;
  ClientException(this.message);

  @override
  String toString() => message;
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => message;
}