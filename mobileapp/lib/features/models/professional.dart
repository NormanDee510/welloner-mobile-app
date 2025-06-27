class Professional {
  final int id;
  final String name;
  // Add other properties as needed

  Professional({required this.id, required this.name});

  factory Professional.fromJson(Map<String, dynamic> json) {
    return Professional(
      id: json['id'],
      name: json['name'],
    );
  }
}