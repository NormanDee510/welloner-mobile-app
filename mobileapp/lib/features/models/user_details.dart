// user_details.dart
class UserDetails {
  final String? id;
  final String name;
  final String email;
  final String? surname;
  final String? gender;
  final int? claimStatusId;
  final String? password;
  final String? roleName;
  final int? roleId;
  final String dateOfBirth;

  UserDetails({
    this.id,
    required this.name,
    required this.email,
    this.surname,
    this.gender,
    this.claimStatusId,
    this.password,
    this.roleName,
    this.roleId,
    required this.dateOfBirth,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id']?.toString(), // Handle different ID types
      name: json['name'] ?? '',
      email: json['email'] ?? json['userName'] ?? '',
      surname: json['surname'],
      gender: json['gender'],
      claimStatusId: json['claimStatusId'] as int?,
      password: json['password'],
      roleName: json['roleName'],
      roleId: json['roleId'] as int?,
      dateOfBirth: json['dateOfBirth'] ?? '', // Default to empty string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userName': email, // Include userName for API consistency
      if (surname != null) 'surname': surname,
      if (gender != null) 'gender': gender,
      if (claimStatusId != null) 'claimStatusId': claimStatusId,
      if (password != null) 'password': password,
      if (roleName != null) 'roleName': roleName,
      if (roleId != null) 'roleId': roleId,
      'dateOfBirth': dateOfBirth, // Include required field
    };
  }

  // For login payload (minimal fields for /api/Auth/login)
  Map<String, dynamic> toLoginJson() {
    return {
      'userName': email.trim(), 
      'password': password ?? '',
    };
  }

  // For registration payload (matches API expectations)
  Map<String, dynamic> toRegistrationJson() {
    return {
      'userName': email,
      'name': name,
      'surname': surname ?? '',
      'gender': gender ?? 'Unknown',
      'claimStatusId': claimStatusId ?? 0,
      'password': password ?? '',
      'roleName': roleName ?? 'User',
      'roleId': roleId ?? 1,
      'dateOfBirth': dateOfBirth,
    };
  }
}

class UserList {
  final List<UserDetails> data;
  final int total;

  UserList({
    required this.data,
    required this.total,
  });

  factory UserList.fromJson(Map<String, dynamic> json) {
    final usersList = (json['data'] as List)
        .map((userJson) => UserDetails.fromJson(userJson))
        .toList();

    return UserList(
      data: usersList,
      total: json['total'] as int? ?? 0,
    );
  }
}