import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobileapp/app/core/constants/environment.dart';
import 'package:mobileapp/features/models/dashboard.dart';
import 'package:mobileapp/features/models/professional.dart';
import 'package:mobileapp/features/models/job.dart';

class DashboardService {
  final http.Client httpClient;

  DashboardService({required this.httpClient});

  Future<List<Professional>> getAllProfessionals() async {
    try {
      final response = await httpClient.get(
        Uri.parse('${Environment.apiBaseUrl}api/Professional'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Professional.fromJson(json)).toList();
      } else {
        throw _handleError('Failed to load professionals', response.statusCode);
      }
    } catch (e) {
      throw _handleError('Client error', 0, e);
    }
  }

  Future<List<Job>> getAllPendingJobs() async {
    try {
      final response = await httpClient.get(
        Uri.parse('${Environment.apiBaseUrl}api/Job/pendingJobs'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Job.fromJson(json)).toList();
      } else {
        throw _handleError('Failed to load pending jobs', response.statusCode);
      }
    } catch (e) {
      throw _handleError('Client error', 0, e);
    }
  }

  Future<DashboardData> getDashboardData() async {
    try {
      // Note: Using hardcoded ID 2 asconsider making dynamic
      final response = await httpClient.get(
        Uri.parse('${Environment.apiBaseUrl}api/Dashboard/2'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return DashboardData.fromJson(json.decode(response.body));
      } else {
        throw _handleError('Failed to load dashboard data', response.statusCode);
      }
    } catch (e) {
      throw _handleError('Client error', 0, e);
    }
  }

  Exception _handleError(String message, int statusCode, [dynamic error]) {
    if (statusCode > 0) {
      print('Server Error ($statusCode): $message');
    } else {
      print('Client Error: $message - ${error?.toString()}');
    }
    return Exception('$message: ${error?.toString() ?? "Status $statusCode"}');
  }
}