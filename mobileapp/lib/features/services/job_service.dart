import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:logger/logger.dart';
import 'package:mobileapp/features/models/job.dart'; // Job model
import 'package:mobileapp/app/core/constants/environment.dart'; // Define `apiBaseUrl` here
//import 'package:mobileapp/features/interface/job.dart';

class JobService {
 // final logger = Logger();
  final headers = {
    'Content-Type': 'application/json',
  };

  Future<List<Job>> getAll() async {
    return _getJobs('${Environment.apiBaseUrl}api/Job/allJobs');
  }

  Future<List<Job>> getAllPendingJobs() async {
    return _getJobs('${Environment.apiBaseUrl}api/Job/pendingJobs');
  }

  Future<List<Job>> getAllJobDefault() async {
    return _getJobs('${Environment.apiBaseUrl}api/Job/pendingJobs');
  }

  Future<List<Job>> getPendingJob(BigInt jobId) async {
    return _getJobs('${Environment.apiBaseUrl}api/Job/$jobId');
  }

  Future<List<Job>> getAssignedJob(BigInt jobId, Job job) async {
    job.id = jobId;
    //logger.i(jsonEncode(job));
    return _getJobs('${Environment.apiBaseUrl}api/Job/${job.id}');
  }

  Future<Job> addPendingJob(BigInt jobId, Job job) async {
    job.id = jobId;
    //logger.i(jsonEncode(job));
    return _postJob('${Environment.apiBaseUrl}api/Job', job);
  }

  Future<Job> updatePendingJob(BigInt jobId, Job job) async {
    return _putJob('${Environment.apiBaseUrl}api/Job/$jobId', jobId, job);
  }

  Future<Job> softDeletePendingJob(BigInt jobId, Job job) async {
    return _putJob('${Environment.apiBaseUrl}api/Job/$jobId', jobId, job);
  }

  Future<Job> updateAssignedJob(BigInt jobId, Job job) async {
    return _putJob('${Environment.apiBaseUrl}api/Job/$jobId', jobId, job);
  }

  Future<Job> updateInProgressJob(BigInt jobId, Job job) async {
    return _putJob('${Environment.apiBaseUrl}api/Job/$jobId', jobId, job);
  }

  Future<Job> updateJobsDefault(BigInt jobId, Job job) async {
    return _putJob('${Environment.apiBaseUrl}api/Job/$jobId', jobId, job);
  }

  Future<Job> updateCompletedJob(BigInt jobId, Job job) async {
    return _putJob('${Environment.apiBaseUrl}api/Job/$jobId', jobId, job);
  }

  Future<void> deletePendingJob(BigInt jobId) async {
    final url = Uri.parse('${Environment.apiBaseUrl}api/Job/$jobId');
    try {
      final response = await http.delete(url);
      _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<List<Job>> getAllAssignedJobs() async {
    return _getJobs('${Environment.apiBaseUrl}api/Job/assignedJobs');
  }

  Future<List<Job>> getAllInProgressJobs() async {
    return _getJobs('${Environment.apiBaseUrl}api/Job/inprogressJobs');
  }

  Future<List<Job>> getAllCompletedJobs() async {
    return _getJobs('${Environment.apiBaseUrl}api/Job/completedJobs');
  }

  // --- Helper Methods ---

  Future<List<Job>> _getJobs(String urlStr) async {
    final url = Uri.parse(urlStr);
    try {
      final response = await http.get(url);
      _handleResponse(response);
      List data = jsonDecode(response.body);
      return data.map((e) => Job.fromJson(e)).toList();
    } catch (e) {
      _handleError(e);
      return [];
    }
  }

  Future<Job> _postJob(String urlStr, Job job) async {
    final url = Uri.parse(urlStr);
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(job.toJson()),
      );
      _handleResponse(response);
      return Job.fromJson(jsonDecode(response.body));
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Job> _putJob(String urlStr, BigInt jobId, Job job) async {
    job.id = jobId;
    final url = Uri.parse(urlStr);
    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(job.toJson()),
      );
      _handleResponse(response);
      return Job.fromJson(jsonDecode(response.body));
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  void _handleError(dynamic error) {
    //logger.e("Error occurred: $error");
    throw Exception("Something went wrong. Please try again later.");
  }
}
