// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import '../widgets/otp_dialog.dart';
import 'dashboard/admin_dashboard.dart';
import 'dashboard/service_provider_dashboard.dart'; // Placeholder for demo

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool useOtp = false;

  void _handleLogin() {
    // Fake login logic
    if (userIdController.text == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminDashboard()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ServiceProviderDashboard()),
      );
    }
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      builder: (_) => OtpDialog(
        onVerified: _handleLogin,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: userIdController,
              decoration: InputDecoration(labelText: 'User ID / Mobile Number'),
            ),
            if (!useOtp)
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            Row(
              children: [
                Checkbox(
                  value: useOtp,
                  onChanged: (value) {
                    setState(() {
                      useOtp = value!;
                    });
                  },
                ),
                Text('Login with OTP')
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: useOtp ? _showOtpDialog : _handleLogin,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                );
              },
              child: Text('Forgot Password?'),
            )
          ],
        ),
      ),
    );
  }
}
