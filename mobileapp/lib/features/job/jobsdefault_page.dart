import 'package:flutter/material.dart';
import 'package:mobileapp/features/services/lookup_service.dart';
import 'package:mobileapp/features/services/user_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jobs List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
  
    );
  }
}

class Job {
    final String shortDescription;
    final String longDescription;
    final String jobTypeName;
    final String jobStatusName;
    final String paymentMethodName;
    final String paymentFrequencyName;
    final String organisationName;
    final String startDate;
    final String endDate;
    final String startTime;
    final String endTime;
    final double paymentAmount;

  Job({
     required this.shortDescription,
     required this.longDescription,
     required this.jobTypeName,
     required this.jobStatusName,
     required this.paymentMethodName,
     required this.paymentFrequencyName,
     required this.organisationName,
     required this.startDate,
     required this.endDate,
     required this.startTime,
     required this.endTime,
     required this.paymentAmount, 
    // required LookupService lookupService, 
    // required UserDetailsService userService,
  });
}

class JobsListScreen extends StatefulWidget {
  const JobsListScreen({
    super.key, 
   // required LookupService lookupService, 
   // required UserDetailsService userService
    });
    
      get lookupService => null;
      
      get userService => null;

  @override
  _JobsListScreenState createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  int currentPage = 1;
  final int totalPages = 5; // Adjust based on your data
  bool isApproved = true; // Example condition
  bool submitted = false;
  //final LookupService lookupService;
  //final UserDetailsService userService;
  // Sample job data
  final List<Job> jobs = List.generate(
    10,
    (index) => Job(
      shortDescription: 'Job $index Short Description',
      longDescription: 'Job $index Long Description',
      jobTypeName: 'Full-Time',
      jobStatusName: 'Open',
      paymentMethodName: 'Bank Transfer',
      paymentFrequencyName: 'Monthly',
      organisationName: 'Company $index',
      startDate: '2025-08-01',
      endDate: '2025-12-31',
      startTime: '09:00 AM',
      endTime: '05:00 PM',
      paymentAmount: 5000.0 + index * 1000,       
      //lookupService: widget.lookupService,  // Fixed service access
      //userService: widget.userService,   
      //required LookupService lookupService, 
      //required UserService userService,
     
    ),
  );

  List<Job> get filteredJobs {
    if (_searchController.text.isEmpty) return jobs;
    return jobs
        .where((job) =>
            job.shortDescription
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            job.organisationName
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
        .toList();
  }

  List<int> getPageRange() {
    return List.generate(totalPages, (index) => index + 1);
  }

  void changePage(int page) {
    if (page >= 1 && page <= totalPages) {
      setState(() {
        currentPage = page;
      });
    }
  }

  void postApplicationDetails(Job job) {
    setState(() {
      submitted = true;
    });
    // Implement application submission logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Applied for ${job.shortDescription}')),
    );
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        submitted = false;
      });
    });
  }

  void showJobDetailsDialog(BuildContext context, Job job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          title: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.yellow.withOpacity(0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.work, color: Colors.black),
                    const SizedBox(width: 8),
                    const Text(
                      'Job Default Details',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job Description Card
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.info, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Job Description',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Short Description',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(job.shortDescription),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Long Description',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(job.longDescription),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Job Details & Schedule Card
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.list_alt, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Job Details & Schedule',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Job Type',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(job.jobTypeName),
                                  const SizedBox(height: 8),
                                  const Text('Organisation',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(job.organisationName),
                                  const SizedBox(height: 8),
                                  const Text('Payment Method',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(job.paymentMethodName),
                                  const SizedBox(height: 8),
                                  const Text('Payment Frequency',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(job.paymentFrequencyName),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Start Date',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  InputDecorator(
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.calendar_today,
                                          color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.blue,
                                      contentPadding:
                                          const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                    child: Text(job.startDate),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('End Date',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  InputDecorator(
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.calendar_today,
                                          color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.blue,
                                      contentPadding:
                                          const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                    child: Text(job.endDate),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('Start Time',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  InputDecorator(
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.access_time,
                                          color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.blue,
                                      contentPadding:
                                          const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                    child: Text(job.startTime),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('End Time',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  InputDecorator(
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.access_time,
                                          color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.blue,
                                      contentPadding:
                                          const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                    child: Text(job.endTime),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('Payment Amount',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  InputDecorator(
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.attach_money,
                                          color: Colors.white),
                                      filled: true,
                                      fillColor: Colors.yellow,
                                      contentPadding:
                                          const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                    child: Text('\$${job.paymentAmount.toStringAsFixed(2)}'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Footer Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      label: const Text('Apply'),
                      onPressed: submitted
                          ? null
                          : () {
                              postApplicationDetails(job);
                              Navigator.of(context).pop();
                            },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs List'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Job name or last name...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),
            // Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: currentPage == 1 ? null : () => changePage(currentPage - 1),
                  child: const Text('Prev'),
                ),
                TextButton(
                  onPressed: () => changePage(1),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        currentPage == 1 ? Colors.blue : Colors.transparent,
                    foregroundColor: currentPage == 1 ? Colors.white : Colors.black,
                  ),
                  child: const Text('1'),
                ),
                for (var page in getPageRange().skip(1))
                  TextButton(
                    onPressed: () => changePage(page),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          currentPage == page ? Colors.blue : Colors.transparent,
                      foregroundColor:
                          currentPage == page ? Colors.white : Colors.black,
                    ),
                    child: Text('$page'),
                  ),
                TextButton(
                  onPressed: currentPage == totalPages
                      ? null
                      : () => changePage(currentPage + 1),
                  child: const Text('Next'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Job List
            Expanded(
              child: ListView.builder(
                itemCount: filteredJobs.length,
                itemBuilder: (context, index) {
                  final job = filteredJobs[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Short Description
                          Text(
                            'Short Description: ${job.shortDescription}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Job Details
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.description, color: Color(0xFF2C3E50)),
                                    SizedBox(width: 8),
                                    Text(
                                      'Job Details',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C3E50),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Text('Job Type: ${job.jobTypeName}'),
                                Text('Job Status: ${job.jobStatusName}'),
                                Text('Payment Method: ${job.paymentMethodName}'),
                                Text('Payment Frequency: ${job.paymentFrequencyName}'),
                                const SizedBox(height: 16),
                                // Action Buttons
                                Wrap(
                                  spacing: 10,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.bar_chart,
                                          color: Color(0xFF3498DB)),
                                      tooltip: 'Analytics',
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.task,
                                          color: Color(0xFF2ECC71)),
                                      tooltip: 'Tasks',
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.settings,
                                          color: Color(0xFFE74C3C)),
                                      tooltip: 'Configuration',
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.speed,
                                          color: Color(0xFFF39C12)),
                                      tooltip: 'Performance',
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.person,
                                          color: Color(0xFF9B59B6)),
                                      tooltip: 'Users',
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // View to Apply Button
                          if (isApproved)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () => showJobDetailsDialog(context, job),
                                child: const Text('View To Apply'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: currentPage == 1 ? null : () => changePage(currentPage - 1),
                  child: const Text('Prev'),
                ),
                TextButton(
                  onPressed: () => changePage(1),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        currentPage == 1 ? Colors.blue : Colors.transparent,
                    foregroundColor: currentPage == 1 ? Colors.white : Colors.black,
                  ),
                  child: const Text('1'),
                ),
                for (var page in getPageRange().skip(1))
                  TextButton(
                    onPressed: () => changePage(page),
                    style: TextButton.styleFrom(
                      backgroundColor:
                          currentPage == page ? Colors.blue : Colors.transparent,
                      foregroundColor:
                          currentPage == page ? Colors.white : Colors.black,
                    ),
                    child: Text('$page'),
                  ),
                TextButton(
                  onPressed: currentPage == totalPages
                      ? null
                      : () => changePage(currentPage + 1),
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}