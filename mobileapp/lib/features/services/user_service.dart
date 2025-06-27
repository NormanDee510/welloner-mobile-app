import 'dart:convert';
import 'package:http/http.dart' as http;

class UserDetailsService {
  final String baseUrl;

  UserDetailsService({required this.baseUrl, required http.Client httpClient});

  // Helper method to create headers
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Error handling similar to Angular service
  dynamic _handleError(http.Response response) {
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
      final response = await http.post(
        Uri.parse('$baseUrl/api/Auth/login'),
        headers: _getHeaders(),
        body: json.encode(user.toJson()),
      );

      _handleError(response);
      return json.decode(response.body);
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  // Get all users
  Future<List<UserDetails>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/User'),
        headers: _getHeaders(),
      );

      _handleError(response);
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserDetails.fromJson(json)).toList();
    } catch (e) {
      print('Get users error: $e');
      rethrow;
    }
  }

  // Get user links
  Future<List<UserDetails>> getUserLinks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/User/LinkUser'),
        headers: _getHeaders(),
      );

      _handleError(response);
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserDetails.fromJson(json)).toList();
    } catch (e) {
      print('Get user links error: $e');
      rethrow;
    }
  }

  // Register user
  Future<UserDetails> registerUser(UserDetails user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/Auth/register'),
        headers: _getHeaders(),
        body: json.encode(user.toJson()),
      );

      _handleError(response);
      return UserDetails.fromJson(json.decode(response.body));
    } catch (e) {
      print('Registration error: $e');
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

// UserDetails model with conversion methods
class UserDetails {
  int? id;
  String userName;
  String password;
  bool isVerified;
  String? passwordHash;
  String? passwordSalt;
  String? lastActive;
  bool isDeleted;
  int roleId;
  String name;
  String surname;
  String gender;
  String dateOfBirth;
  int? linkFromUserId;
  int linkToUserId;
  String? roleName;

  UserDetails({
    this.id,
    required this.userName,
    required this.password,
    this.isVerified = false,
    this.passwordHash,
    this.passwordSalt,
    this.lastActive,
    this.isDeleted = false,
    required this.roleId,
    required this.name,
    required this.surname,
    required this.gender,
    required this.dateOfBirth,
    this.linkFromUserId,
    this.linkToUserId = 0,
    this.roleName,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'password': password,
      'isVerified': isVerified,
      'passwordHash': passwordHash,
      'passwordSalt': passwordSalt,
      'lastActive': lastActive,
      'isDeleted': isDeleted,
      'roleId': roleId,
      'name': name,
      'surname': surname,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'linkFromUserId': linkFromUserId,
      'linkToUserId': linkToUserId,
      'roleName': roleName,
    };
  }

  // Create from JSON
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      userName: json['userName'],
      password: json['password'],
      isVerified: json['isVerified'] ?? false,
      passwordHash: json['passwordHash'],
      passwordSalt: json['passwordSalt'],
      lastActive: json['lastActive'],
      isDeleted: json['isDeleted'] ?? false,
      roleId: json['roleId'],
      name: json['name'],
      surname: json['surname'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      linkFromUserId: json['linkFromUserId'],
      linkToUserId: json['linkToUserId'] ?? 0,
      roleName: json['roleName'],
    );
  }
}