class Job {
  dynamic id;
  dynamic jobId;
  String shortDescription;
  String longDescription;
  int jobTypeId;
  int jobStatusId;
  int organisationId;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  int paymentMethodId;
  int paymentFrequencyId;
  double paymentAmount;
  bool isDeleted;
  String lastChangedDate;
  String createdDate;
  int lastChangedBy;
  int createdBy;
  String jobStatusName;

  Job({
    this.id,
    this.jobId,
    required this.shortDescription,
    required this.longDescription,
    required this.jobTypeId,
    required this.jobStatusId,
    required this.organisationId,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.paymentMethodId,
    required this.paymentFrequencyId,
    required this.paymentAmount,
    required this.isDeleted,
    required this.lastChangedDate,
    required this.createdDate,
    required this.lastChangedBy,
    required this.createdBy,
    required this.jobStatusName,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      jobId: json['jobId'],
      shortDescription: json['shortDescription'],
      longDescription: json['longDescription'],
      jobTypeId: json['jobTypeId'],
      jobStatusId: json['jobStatusId'],
      organisationId: json['organisationId'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      paymentMethodId: json['paymentMethodId'],
      paymentFrequencyId: json['paymentFrequencyId'],
      paymentAmount: (json['paymentAmount'] as num).toDouble(),
      isDeleted: json['isDeleted'],
      lastChangedDate: json['lastChangedDate'],
      createdDate: json['createdDate'],
      lastChangedBy: json['lastChangedBy'],
      createdBy: json['createdBy'],
      jobStatusName: json['jobStatusName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'jobTypeId': jobTypeId,
      'jobStatusId': jobStatusId,
      'organisationId': organisationId,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'paymentMethodId': paymentMethodId,
      'paymentFrequencyId': paymentFrequencyId,
      'paymentAmount': paymentAmount,
      'isDeleted': isDeleted,
      'lastChangedDate': lastChangedDate,
      'createdDate': createdDate,
      'lastChangedBy': lastChangedBy,
      'createdBy': createdBy,
      'jobStatusName': jobStatusName,
    };
  }
}
