import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../app/core/constants/environment.dart';

class LookupItemBase {
  final int id;
  final String name;

  LookupItemBase({required this.id, required this.name});

  factory LookupItemBase.fromJson(Map<String, dynamic> json) {
    return LookupItemBase(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Town {
  final int id;
  final String name;

  Town({required this.id, required this.name});

  factory Town.fromJson(Map<String, dynamic> json) {
    return Town(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Suburb {
  final int id;
  final String name;

  Suburb({required this.id, required this.name});

  factory Suburb.fromJson(Map<String, dynamic> json) {
    return Suburb(
      id: json['id'],
      name: json['name'],
    );
  }
}

class LookupService {
  final http.Client httpClient;

  LookupService({required this.httpClient});

  Future<List<T>> _fetchList<T>(String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    try {
      // Use Environment for base URL
      final url = '${Environment.apiBaseUrl}$endpoint';
      final response = await httpClient.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((item) => fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw _handleError('Server error', response.statusCode);
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

  // Lookup methods
  Future<List<LookupItemBase>> getHealthInstitutions() => 
      _fetchList('api/HealthInstitution', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getBookingStatus() => 
      _fetchList('api/BookingStatus', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getGenders() => 
      _fetchList('api/Gender', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getIdentityTypes() => 
      _fetchList('api/IdentityType', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getJobApplicationStatuses() => 
      _fetchList('api/JobApplicationStatus', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getJobStatuses() => 
      _fetchList('api/JobStatus', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getJobTypes() => 
      _fetchList('api/JobType', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getLanguages() => 
      _fetchList('api/Language', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getOrganisationTypes() => 
      _fetchList('api/OrganisationType', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getOrganisations() => 
      _fetchList('api/Organisation', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getPaymentFrequencies() => 
      _fetchList('api/PaymentFrequency', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getPaymentMethods() => 
      _fetchList('api/PaymentMethod', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getProfessionalTypes() => 
      _fetchList('api/ProfessionalType', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getProvinces() => 
      _fetchList('api/Province', LookupItemBase.fromJson);

  Future<List<Suburb>> getSuburbs() => 
      _fetchList('api/Suburb', Suburb.fromJson);

  Future<List<LookupItemBase>> getTitles() => 
      _fetchList('api/Title', LookupItemBase.fromJson);

  Future<List<Town>> getTowns() => 
      _fetchList('api/Town', Town.fromJson);

  Future<List<LookupItemBase>> getCountries() => 
      _fetchList('api/Country', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getEventStatuses() => 
      _fetchList('api/EventStatus', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getVisitTypes() => 
      _fetchList('api/VisitType', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getVisitStatus() => 
      _fetchList('api/VisitStatus', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getIssueTypes() => 
      _fetchList('api/IssueType', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getIssueStatus() => 
      _fetchList('api/IssueStatus', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getVerificationStatus() => 
      _fetchList('api/VerificationStatus', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getSpecialties() => 
      _fetchList('api/Specialty', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getChannel() => 
      _fetchList('api/Channel', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getRoleTypes() => 
      _fetchList('api/RoleType', LookupItemBase.fromJson);

  Future<List<LookupItemBase>> getVisitChannel() => 
      _fetchList('api/Channel', LookupItemBase.fromJson);
}// TODO Implement this library.