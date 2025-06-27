import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:mobileapp/features/services/dashboard_service.dart';
//import 'package:mobileapp/services/professional_event_service.dart';
//import 'package:mobileapp/services/chat_service.dart';
//import 'package:mobileapp/services/job_service.dart';
//import 'package:mobileapp/models/dashboard.dart';
//import 'package:mobileapp/models/professional_event.dart';
//import 'package:mobileapp/models/job.dart';
//import 'package:mobileapp/models/message.dart';
import 'package:mobileapp/app/core/constants/environment.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required lookupService, required userService});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Calendar state
  final CalendarController _calendarController = CalendarController();
  List<Appointment> _calendarEvents = [];
  
  // Map state
  final Set<Marker> _markers = {};
  LatLng _mapCenter = const LatLng(-26.150430, 28.150230);
  double _zoom = 17.0;
  
  // Charts state
  List<PieChartSectionData> _donutChartSections = [];
  List<FlSpot> _pendingJobsData = [];
  List<FlSpot> _completedJobsData = [];
  
  // Chat state
  // final TextEditingController _messageController = TextEditingController();
  // final List<Message> _messages = [];
  // int? _userId;
  // int? _receiverUserId;
  
  // Dashboard data
  //DashboardData? _dashboardData;
  
  // Services
  late DashboardService _dashboardService;
  // late ProfessionalEventService _eventService;
  // late ChatService _chatService;
  // late JobService _jobService;

  @override
  void initState() {
    super.initState();
   // _dashboardService = DashboardService(httpClient: null);
    // _eventService = ProfessionalEventService();
    // _chatService = ChatService();
    // _jobService = JobService();
    
    _initializeDashboard();
   // _loadUserData();
  }

  void _initializeDashboard() async {
   // await _loadCalendarEvents();
    await _loadDashboardData();
   // await _loadJobAnalytics();
    _initGeolocation();
  }

  // void _loadUserData() {
  //   // TODO: Replace with actual user loading logic
  //   setState(() {
  //     _userId = 1;
  //     _receiverUserId = 2;
  //   });
  //   _loadMessages();
  // }

  // Future<void> _loadCalendarEvents() async {
  //   final events = await _eventService.getProfessionalEvents();
  //   setState(() {
  //     _calendarEvents = events.map((event) {
  //       return Appointment(
  //         startTime: event.startDate,
  //         endTime: event.endDate,
  //         subject: event.shortDescription,
  //         color: Colors.teal,
  //       );
  //     }).toList();
  //   });
  // }

  Future<void> _loadDashboardData() async {
    final data = await _dashboardService.getDashboardData();
    setState(() {
    //  _dashboardData = data;
      _updateDonutChart();
    });
  }

  // Future<void> _loadJobAnalytics() async {
  //   final pendingJobs = await _jobService.getPendingJobs();
  //   final completedJobs = await _jobService.getCompletedJobs();
    
  //   // Convert to chart data points
  //   setState(() {
  //     _pendingJobsData = _convertJobsToChartData(pendingJobs);
  //     _completedJobsData = _convertJobsToChartData(completedJobs);
  //   });
  // }

  // List<FlSpot> _convertJobsToChartData(List<Job> jobs) {
  //   return jobs.asMap().entries.map((e) {
  //     return FlSpot(e.key.toDouble(), e.value.id.toDouble());
  //   }).toList();
  // }

  void _updateDonutChart() {
   // if (_dashboardData == null) return;
    
    setState(() {
      _donutChartSections = [
        PieChartSectionData(
       //   value: _dashboardData!.pendingJobs.toDouble(),
          color: Colors.blue,
          title: 'Pending',
        ),
        PieChartSectionData(
        //  value: _dashboardData!.completedJobs.toDouble(),
          color: Colors.green,
          title: 'Completed',
        ),
      ];
    });
  }

  void _initGeolocation() async {
    // TODO: Implement actual geolocation logic
    _addMarker(const LatLng(-26.150430, 28.150230));
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: const InfoWindow(title: 'Professional Address'),
        ),
      );
    });
  }

  // Future<void> _loadMessages() async {
  //   if (_userId == null || _receiverUserId == null) return;
    
  //   final messages = await _chatService.getMessages(_userId!, _receiverUserId!);
  //   setState(() {
  //     _messages = messages;
  //   });
  // }

  // void _sendMessage() {
  //   if (_messageController.text.isEmpty) return;
  //   if (_userId == null || _receiverUserId == null) return;
    
  //   final newMessage = Message(
  //     message: _messageController.text,
  //     senderUserId: _userId!,
  //     receiverUserId: _receiverUserId!,
  //     createdDate: DateTime.now(),
  //     type: 'sent',
  //   );
    
  //   _chatService.sendMessage(newMessage).then((_) {
  //     setState(() {
  //       _messages.add(newMessage);
  //       _messageController.clear();
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Calendar Section
            _buildCalendarSection(),
            
            // Map Section
            _buildMapSection(),
            
            // Charts Section
            _buildChartsSection(),
            
            // Chat Section
            _buildChatSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 300,
            child: SfCalendar(
              view: CalendarView.month,
              controller: _calendarController,
              dataSource: _CalendarDataSource(_calendarEvents),
              monthViewSettings: const MonthViewSettings(
                showAgenda: true,
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Professional Locations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _mapCenter,
                zoom: _zoom,
              ),
              markers: _markers,
              onMapCreated: (controller) {},
              onTap: (position) => _addMarker(position),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.zoom_in),
                onPressed: () => setState(() => _zoom = (_zoom + 1).clamp(13.0, 20.0)),
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out),
                onPressed: () => setState(() => _zoom = (_zoom - 1).clamp(13.0, 20.0)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Job Analytics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          // Donut Chart
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _donutChartSections,
                centerSpaceRadius: 60,
              ),
            ),
          ),
          // Line Chart
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _pendingJobsData,
                    color: Colors.blue,
                    isCurved: true,
                  ),
                  LineChartBarData(
                    spots: _completedJobsData,
                    color: Colors.green,
                    isCurved: true,
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatSection() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Messages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              reverse: true,
              //itemCount: _messages.length,
              itemBuilder: (context, index) {
              //  final message = _messages[index];
                // return ListTile(
                //   title: Align(
                //     alignment: message.type == 'sent' 
                //         ? Alignment.centerRight 
                //         : Alignment.centerLeft,
                //     child: Container(
                //       padding: const EdgeInsets.all(8),
                //       decoration: BoxDecoration(
                //         color: message.type == 'sent' ? Colors.blue[100] : Colors.grey[300],
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       child: Text(message.message),
                //     ),
                //   ),
                // );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            // child: Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         controller: _messageController,
            //         decoration: const InputDecoration(
            //           hintText: 'Type your message...',
            //         ),
            //       ),
            //     ),
            //     IconButton(
            //       icon: const Icon(Icons.send),
            //       onPressed: _sendMessage,
            //     ),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }
}

class _CalendarDataSource extends CalendarDataSource {
  _CalendarDataSource(List<Appointment> source) {
    appointments = source;
  }
}