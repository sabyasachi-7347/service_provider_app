// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import '../widgets/otp_dialog.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import 'dashboard/admin_dashboard.dart';
import 'dashboard/service_provider_dashboard.dart'; // Placeholder for demo
import 'dashboard/consumer_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool useOtp = false;
  bool _isLoading = false;

  @override
  void dispose() {
    userIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      final response = await ApiService.login(
        userId: userIdController.text.trim(),
        password: passwordController.text,
      );
      final user = AppUser.fromJson(response['user'] as Map<String, dynamic>);

      if (!mounted) return;
      if (user.role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else if (user.role == 'service_provider') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceProviderDashboard(user: user),
          ),
        );
      } else if (user.role == 'consumer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ConsumerDashboard(user: user)),
        );
      } else {
        throw Exception('Unknown user role');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showOtpDialog() {
    final mobile = userIdController.text.trim();
    if (mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your User ID / Mobile Number first'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (_) => OtpDialog(
            mobile: mobile,
            onVerified: () {
              _handleLogin();
            },
          ),
    );
  }

  void _requestService() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ConsumerDashboard(user: null)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4F46E5);
    const Color accentColor = Color(0xFF7C3AED);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEEF2FF), Color(0xFFF5F3FF), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Color(0xFFE0E7FF),
                          child: Icon(Icons.lock_outline, color: primaryColor),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Welcome Back',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Sign in to continue to your account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: userIdController,
                          decoration: InputDecoration(
                            labelText: 'User ID / Mobile Number',
                            prefixIcon: const Icon(Icons.person_outline),
                            filled: true,
                            fillColor: const Color(0xFFF9FAFB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (!useOtp)
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.key_outlined),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SwitchListTile(
                            title: const Text(
                              'Login with OTP',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            value: useOtp,
                            activeColor: accentColor,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            onChanged: (value) {
                              setState(() {
                                useOtp = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                _isLoading
                                    ? null
                                    : useOtp
                                    ? _showOtpDialog
                                    : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              _isLoading ? 'Signing in...' : 'Login',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: accentColor),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _requestService,
                          icon: const Icon(
                            Icons.support_agent_outlined,
                            color: primaryColor,
                          ),
                          label: const Text(
                            'Request Service',
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
