import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:syncfusion_flutter_calendar/calendar.dart';
//import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Fixed percentages to use double values
  final dashboardData = {
    'dashNumberOfCompleteJobsInCurrentMonth': 42,
    'completedJobsInCurrentMonthPercentage': 70.1,
    'dashNumberOfPendingJobsInCurrentMonth': 24,
    'numberOfPendingJobsInCurrentMonthPercentage': 40.5,
    'nextMonthJobs': 35,
    'nextMonthJobsPercentage': 76.3,
    'allCompletedJobs': 128,
    'completedJobsPercentage': 90.9,
    'dashTotalNumberOfPendingJobs': 56,
    'totalNumberOfPendingJobHistoryPercentage': 45.2,
    'totalNumberOfCompletedJobHistoryPercentage': 54.8,
  };

  final List<Map<String, dynamic>> professionalSuburbs = [
    {'suburbName': 'Sandton', 'percentage': 32.0},
    {'suburbName': 'Midrand', 'percentage': 24.0},
    {'suburbName': 'Rosebank', 'percentage': 18.0},
    {'suburbName': 'Fourways', 'percentage': 14.0},
    {'suburbName': 'Randburg', 'percentage': 12.0},
  ];

  final List<Map<String, dynamic>> recentJobs = [
    {'suburbNames': 'Sandton', 'jobShortDescription': 'Plumbing repair', 'jobCreatedDate': '2023-06-15'},
    {'suburbNames': 'Midrand', 'jobShortDescription': 'Electrical installation', 'jobCreatedDate': '2023-06-14'},
    {'suburbNames': 'Rosebank', 'jobShortDescription': 'HVAC maintenance', 'jobCreatedDate': '2023-06-13'},
    {'suburbNames': 'Fourways', 'jobShortDescription': 'Carpentry work', 'jobCreatedDate': '2023-06-12'},
  ];

  // Map variables
  final LatLng _mapCenter = const LatLng(-26.150430, 28.150230);
  double _zoom = 17.0;
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;

  // Calendar variables
  //final CalendarController _calendarController = CalendarController();
  //final List<Appointment> _calendarEvents = [];

  // Chat variables
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _addMarkers();
   // _loadCalendarEvents();
    _loadMessages();
  }

  void _addMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('marker_1'),
          position: const LatLng(-26.150430, 28.150230),
          infoWindow: const InfoWindow(title: 'Professional Location'),
        ),
      );
    });
  }

  // void _loadCalendarEvents() {
  //   setState(() {
  //     _calendarEvents.add(Appointment(
  //       startTime: DateTime.now().add(const Duration(hours: 2)),
  //       endTime: DateTime.now().add(const Duration(hours: 4)),
  //       subject: 'Meeting with Client',
  //       color: Colors.teal,
  //     ));
  //   });
  // }

  void _loadMessages() {
    setState(() {
      _messages.addAll([
        {'senderUserId': 1, 'message': 'Hello, when can you start?', 'createdDate': DateTime.now().subtract(const Duration(minutes: 15))},
        {'senderUserId': 2, 'message': 'I can start tomorrow morning', 'createdDate': DateTime.now().subtract(const Duration(minutes: 10))},
        {'senderUserId': 1, 'message': 'Perfect! See you then', 'createdDate': DateTime.now().subtract(const Duration(minutes: 5))},
      ]);
    });
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;
    
    setState(() {
      _messages.add({
        'senderUserId': 1,
        'message': _messageController.text,
        'createdDate': DateTime.now(),
      });
      _messageController.clear();
    });
  }

  // Function to update map zoom
  void _updateZoom(double zoomDelta) {
    setState(() {
      _zoom += zoomDelta;
      _zoom = _zoom.clamp(13.0, 20.0);
    });
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: _mapCenter, zoom: _zoom),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb
              _buildBreadcrumb(),
              const SizedBox(height: 16),
              
              // Page Header
              _buildPageHeader(),
              const SizedBox(height: 24),
              
              // Stats Cards
              _buildStatsCards(),
              const SizedBox(height: 24),
              
              // Analytics Row
              _buildAnalyticsRow(),
              const SizedBox(height: 24),
              
              // Bottom Row
              _buildBottomRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Row(
      children: [
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          child: const Text(
            'Home',
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text('›', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        const Text(
          'Dashboard',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Overview of your operations',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          icon: Icons.check_circle,
          title: "THIS MONTH'S JOBS COMPLETED",
          value: dashboardData['dashNumberOfCompleteJobsInCurrentMonth'].toString(),
          percentage: dashboardData['completedJobsInCurrentMonthPercentage'] as double,
          progressColor: Colors.teal,
          bgColor: Colors.teal,
        ),
        _buildStatCard(
          icon: Icons.access_time,
          title: "THIS MONTH'S JOBS PENDING",
          value: dashboardData['dashNumberOfPendingJobsInCurrentMonth'].toString(),
          percentage: dashboardData['numberOfPendingJobsInCurrentMonthPercentage'] as double,
          progressColor: Colors.blue,
          bgColor: Colors.blue,
        ),
        _buildStatCard(
          icon: Icons.calendar_month,
          title: "NEXT MONTH'S JOBS",
          value: dashboardData['nextMonthJobs'].toString(),
          percentage: dashboardData['nextMonthJobsPercentage'] as double,
          progressColor: Colors.indigo,
          bgColor: Colors.indigo,
        ),
        _buildStatCard(
          icon: Icons.workspace_premium,
          title: "ALL TIME JOBS COMPLETED",
          value: dashboardData['allCompletedJobs'].toString(),
          percentage: dashboardData['completedJobsPercentage'] as double,
          progressColor: Colors.grey[800]!,
          bgColor: Colors.grey[800]!,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required double percentage,
    required Color progressColor,
    required Color bgColor,
  }) {
    return Card(
      color: bgColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, color: Colors.white.withOpacity(0.7), size: 32),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.white.withOpacity(0.3),
              color: Colors.white,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 8),
            Text(
              '${percentage.toStringAsFixed(1)}% of target',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsRow() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Jobs Analytics Chart
            Expanded(
              flex: 2,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Jobs Analytics',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Jobs progress overview',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: SizedBox(
                        height: 250,
                      //  child: _JobsLineChart(), // Actual chart implementation
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey[100],
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                dashboardData['dashTotalNumberOfPendingJobs'].toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Total Jobs',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              height: 150,
                              //child: _JobsDonutChart(), // Actual chart implementation
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.circle, color: Colors.blue, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                '${dashboardData['totalNumberOfPendingJobHistoryPercentage']?.toStringAsFixed(1)}% Pending',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              Icon(Icons.circle, color: Colors.teal, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                '${dashboardData['totalNumberOfCompletedJobHistoryPercentage']?.toStringAsFixed(1)}% Completed',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Professionals Map
            Expanded(
              flex: 1,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Professionals Origin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.zero),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _mapCenter,
                            zoom: _zoom,
                          ),
                          markers: _markers,
                          onMapCreated: (controller) {
                            _mapController = controller;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _updateZoom(1),
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Zoom In'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _updateZoom(-1),
                              icon: const Icon(Icons.remove, size: 16),
                              label: const Text('Zoom Out'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...professionalSuburbs.map((suburb) => ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.teal),
                      title: Text(suburb['suburbName']),
                      trailing: Chip(
                        label: Text('${suburb['percentage']}%'),
                        backgroundColor: Colors.teal.withOpacity(0.2),
                      ),
                    )).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Messages Panel
        Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Messages',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        label: Text('${_messages.length} unread'),
                        backgroundColor: Colors.teal.withOpacity(0.2),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isSent = message['senderUserId'] == 1;
                      final time = message['createdDate'] as DateTime;
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: isSent 
                              ? MainAxisAlignment.end 
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.6,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSent ? Colors.blue[100] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(message['message']),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Calendar
        Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Today's Schedule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 300,
                //   child: SfCalendar(
                //     view: CalendarView.day,
                //     controller: _calendarController,
                //     dataSource: _CalendarDataSource(_calendarEvents),
                //     monthViewSettings: const MonthViewSettings(
                //       showAgenda: true,
                //       appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                //     ),
                //     headerHeight: 0, // Hide header
                //   ),
                // ),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Add Event'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Recent Jobs
        Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Jobs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        label: Text('${dashboardData['dashTotalNumberOfPendingJobs']} total'),
                        backgroundColor: Colors.teal.withOpacity(0.2),
                      ),
                    ],
                  ),
                ),
                ...recentJobs.map((job) => ListTile(
                  title: Text(job['suburbNames']),
                  subtitle: Text(job['jobShortDescription']),
                  trailing: Text(job['jobCreatedDate']),
                )).toList(),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('View All Jobs'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// class _CalendarDataSource extends CalendarDataSource {
//   _CalendarDataSource(List<Appointment> source) {
//     appointments = source;
//   }
// }

// Line chart implementation
// class _JobsLineChart extends StatelessWidget {
//   const _JobsLineChart();

//   @override
//   // Widget build(BuildContext context) {
//   //   return LineChart(
//   //     LineChartData(
//   //       gridData: FlGridData(show: true),
//   //       titlesData: FlTitlesData(show: true),
//   //       borderData: FlBorderData(show: true),
//   //       minX: 0,
//   //       maxX: 11,
//   //       minY: 0,
//   //       maxY: 6,
//   //       lineBarsData: [
//   //         LineChartBarData(
//   //           spots: [
//   //             FlSpot(0, 3),
//   //             FlSpot(2.6, 2),
//   //             FlSpot(4.9, 5),
//   //             FlSpot(6.8, 3.1),
//   //             FlSpot(8, 4),
//   //             FlSpot(9.5, 3),
//   //             FlSpot(11, 4),
//   //           ],
//   //           isCurved: true,
//   //           color: Colors.blue,
//   //           barWidth: 4,
//   //           belowBarData: BarAreaData(show: false),
//   //         ),
//   //         LineChartBarData(
//   //           spots: [
//   //             FlSpot(0, 4),
//   //             FlSpot(2.6, 3),
//   //             FlSpot(4.9, 4),
//   //             FlSpot(6.8, 6),
//   //             FlSpot(8, 3),
//   //             FlSpot(9.5, 5),
//   //             FlSpot(11, 3),
//   //           ],
//   //           isCurved: true,
//   //           color: Colors.teal,
//   //           barWidth: 4,
//   //           belowBarData: BarAreaData(show: false),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
// }

// // Donut chart implementation
// // class _JobsDonutChart extends StatelessWidget {
//   const _JobsDonutChart();

//   @override
//   Widget build(BuildContext context) {
//     return PieChart(
//       PieChartData(
//         sectionsSpace: 0,
//         centerSpaceRadius: 40,
//         sections: [
//           PieChartSectionData(
//             color: Colors.blue,
//             value: 45.2,
//             showTitle: false,
//             radius: 20,
//           ),
//           PieChartSectionData(
//             color: Colors.teal,
//             value: 54.8,
//             showTitle: false,
//             radius: 20,
//           ),
//         ],
//       ),
//     );
//   }
// }