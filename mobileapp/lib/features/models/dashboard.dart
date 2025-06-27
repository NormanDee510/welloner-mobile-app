class Dashboard {
  final int dashTotalNumberOfPendingJobs;
  final int dashNumberOfCompleteJobsInCurrentMonth;
  // Add other properties from your API response

  Dashboard({
    required this.dashTotalNumberOfPendingJobs,
    required this.dashNumberOfCompleteJobsInCurrentMonth,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      dashTotalNumberOfPendingJobs: json['dashTotalNumberOfPendingJobs'],
      dashNumberOfCompleteJobsInCurrentMonth: 
          json['dashNumberOfCompleteJobsInCurrentMonth'],
    );
  }
}