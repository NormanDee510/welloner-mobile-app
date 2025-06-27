class Job {
  final int id;
  final String status;
  // Add other properties as needed

  Job({required this.id, required this.status});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      status: json['status'],
    );
  }
}