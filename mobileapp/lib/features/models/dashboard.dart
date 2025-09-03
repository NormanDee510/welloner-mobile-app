class DashboardData {
  final int dashTotalNumberOfPendingJobs;
  final int dashNumberOfCompleteJobsInCurrentMonth;
  final double completedJobsInCurrentMonthPercentage;
  final int dashNumberOfPendingJobsInCurrentMonth;
  final double numberOfPendingJobsInCurrentMonthPercentage;
  final int nextMonthJobs;
  final double nextMonthJobsPercentage;
  final int allCompletedJobs;
  final double completedJobsPercentage;
  final double totalNumberOfPendingJobHistoryPercentage;
  final double totalNumberOfCompletedJobHistoryPercentage;

  DashboardData({
    required this.dashTotalNumberOfPendingJobs,
    required this.dashNumberOfCompleteJobsInCurrentMonth,
    required this.completedJobsInCurrentMonthPercentage,
    required this.dashNumberOfPendingJobsInCurrentMonth,
    required this.numberOfPendingJobsInCurrentMonthPercentage,
    required this.nextMonthJobs,
    required this.nextMonthJobsPercentage,
    required this.allCompletedJobs,
    required this.completedJobsPercentage,
    required this.totalNumberOfPendingJobHistoryPercentage,
    required this.totalNumberOfCompletedJobHistoryPercentage,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      dashTotalNumberOfPendingJobs: json['dashTotalNumberOfPendingJobs'] ?? 0,
      dashNumberOfCompleteJobsInCurrentMonth: json['dashNumberOfCompleteJobsInCurrentMonth'] ?? 0,
      completedJobsInCurrentMonthPercentage: (json['completedJobsInCurrentMonthPercentage'] ?? 0).toDouble(),
      dashNumberOfPendingJobsInCurrentMonth: json['dashNumberOfPendingJobsInCurrentMonth'] ?? 0,
      numberOfPendingJobsInCurrentMonthPercentage: (json['numberOfPendingJobsInCurrentMonthPercentage'] ?? 0).toDouble(),
      nextMonthJobs: json['nextMonthJobs'] ?? 0,
      nextMonthJobsPercentage: (json['nextMonthJobsPercentage'] ?? 0).toDouble(),
      allCompletedJobs: json['allCompletedJobs'] ?? 0,
      completedJobsPercentage: (json['completedJobsPercentage'] ?? 0).toDouble(),
      totalNumberOfPendingJobHistoryPercentage: (json['totalNumberOfPendingJobHistoryPercentage'] ?? 0).toDouble(),
      totalNumberOfCompletedJobHistoryPercentage: (json['totalNumberOfCompletedJobHistoryPercentage'] ?? 0).toDouble(),
    );
  }
}
