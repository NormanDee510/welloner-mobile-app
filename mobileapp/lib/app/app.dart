import 'package:flutter/material.dart';
import 'package:mobileapp/features/auth/pages/register_page.dart';
import 'package:mobileapp/features/auth/pages/login_page.dart';
import 'package:mobileapp/features/dashboard/dashboard_page.dart';
import 'package:mobileapp/features/services/auth_service.dart';
import 'package:mobileapp/features/services/lookup_service.dart';
import 'package:mobileapp/features/services/user_service.dart';
import 'package:mobileapp/features/job/jobsdefault_page.dart';


class MyApp extends StatelessWidget {
  final LookupService lookupService;
  final UserDetailsService userService;
  final  AuthService authService;

  const MyApp({
    Key? key,
    required this.lookupService,
    required this.userService,
    required this.authService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WellOner App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/register_page': (context) => RegisterPage(
             userService: userService, 
             lookupService: lookupService,
            ),
        '/login_page': (context) => LoginPage(
              authService: authService, 
              lookupService: lookupService,
            ),
        '/dashboard_page': (context) => DashboardPage(
          lookupService: lookupService,
          userService: userService,
        ),
        // '/jobsdefault_page': (context) => JobsDefaultPage(
        //       lookupService: lookupService, // Pass services if needed
        //       userService: userService,
        // ),
      },
      home: RegisterPage(
        lookupService: lookupService,  
        userService: userService,
        ),
    );
  }
}