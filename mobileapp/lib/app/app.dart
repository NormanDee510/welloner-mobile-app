import 'package:flutter/material.dart';
import 'package:mobileapp/features/auth/pages/register_page.dart';
import 'package:mobileapp/features/auth/pages/login_page.dart';
import 'package:mobileapp/features/dashboard/dashboard_page.dart';
import 'package:mobileapp/features/services/lookup_service.dart';
import 'package:mobileapp/features/services/user_service.dart';


class MyApp extends StatelessWidget {
  final LookupService lookupService;
  final UserDetailsService userService;

  const MyApp({
    Key? key,
    required this.lookupService,
    required this.userService,
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
              userService: userService, 
              lookupService: lookupService,
            ),
        '/dashboard_page': (context) => DashboardPage(
          lookupService: lookupService,
          userService: userService,
        ),
      },
      home: RegisterPage(
        lookupService: lookupService,  
        userService: userService,
        ),
    );
  }
}