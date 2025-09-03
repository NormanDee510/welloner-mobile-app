import 'package:flutter/material.dart';
import 'package:mobileapp/app/routes.dart';
import 'package:mobileapp/features/services/auth_service.dart';
import 'package:mobileapp/features/services/lookup_service.dart';
//import 'package:mobileapp/config/app_settings.dart';

class LoginPage extends StatefulWidget {
  final LookupService lookupService;
  final AuthService authService;

  const LoginPage({
    Key? key,
    required this.lookupService,
    required this.authService,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submittedForm = false;
  bool _isLoading = false;
  String _loginError = '';

  @override
  void initState() {
    super.initState();
    //AppSettings.appEmpty = true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    //AppSettings.appEmpty = false;
    super.dispose();
  }

  void _userLogin() async {
    setState(() {
      _submittedForm = true;
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _loginError = '';
      });

      try {
        final user = await widget.authService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful! Welcome')),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard).then((_) {
            // Simulate window.location.reload() by resetting state
            setState(() {});
          });
        } else {
          setState(() {
            _loginError = 'Login failed: Unexpected response';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed. Check your credentials.')),
          );
        }
      } catch (e) {
        print('Login error: $e');
        setState(() {
          _loginError = 'Login error: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Check your credentials.')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onGoToSignUp() {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/login-bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Center(
                    child: Column(
                      children: [
                        // Uncomment once assets are fixed
                        // Image.asset('assets/logo.png', height: 80, width: 80),
                        const SizedBox(height: 16),
                        const Text(
                          'WellOner',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Be Well, Everyday',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'email@gmail.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  if (_loginError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        _loginError,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _userLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Sign me in',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                 Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register_page');
                    },
                    child: const Text(
                      'Don’t have an account? Register here',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
