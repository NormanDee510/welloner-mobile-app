import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/features/auth/pages/dashboard_screen.dart';
import 'package:mobileapp/features/services/auth_service.dart';
import 'package:mobileapp/features/services/lookup_service.dart';
import 'package:mobileapp/features/services/user_service.dart';
import 'package:mobileapp/features/auth/pages/register_page.dart';
import 'package:provider/provider.dart';
import 'package:mobileapp/app/core/constants/environment.dart';
import 'package:mobileapp/features/auth/pages/login_page.dart';
import 'package:mobileapp/app/routes.dart';
import 'package:mobileapp/features/job/jobsdefault_page.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        // Create http.Client provider with proper disposal
        Provider<http.Client>(
          create: (_) => http.Client(),
          dispose: (_, client) => client.close(),
        ),
        
        // LookupService now gets http.Client from provider
        Provider<LookupService>(
          create: (context) => LookupService(
            httpClient: Provider.of<http.Client>(context, listen: false),
          ),
        ),
        
        // UserDetailsService with base URL and http.Client
        Provider<UserDetailsService>(
          create: (context) => UserDetailsService(
            apiBaseUrl: Environment.apiBaseUrl, 
            httpClient: Provider.of<http.Client>(context, listen: false),
          ),
        ),
          // AuthService with base URL and http.Client
        Provider<AuthService>(
          create: (context) => AuthService(
            apiBaseUrl: Environment.apiBaseUrl, 
            httpClient: Provider.of<http.Client>(context, listen: false),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access services using Provider
    final lookupService = Provider.of<LookupService>(context, listen: false);
    final userService = Provider.of<UserDetailsService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return MaterialApp(
      title: 'WellOner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: AppRoutes.login,
      routes:{
        AppRoutes.login:(context) => LoginPage(
        lookupService: lookupService,
        authService:  authService,
      ),
         AppRoutes.register:(context) => RegisterPage(
        lookupService: lookupService,
        userService: userService,
      ),
          AppRoutes.dashboard:(context) => DashboardPage(),
         // AppRoutes.job:(context) => Job(),
      
      }, 
    );
    
  }
}