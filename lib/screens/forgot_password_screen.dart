// screens/forgot_password_screen.dart
import 'package:flutter/material.dart';
import '../widgets/otp_dialog.dart';
import 'set_new_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool useEmail = true;
  final TextEditingController inputController = TextEditingController();

  void _handleReset() {
    if (useEmail) {
      // Simulate sending reset link
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reset link sent to ${inputController.text}')),
      );
    } else {
      // Simulate OTP flow
      showDialog(
        context: context,
        builder: (_) => OtpDialog(
          onVerified: () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => SetNewPasswordScreen()),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [useEmail, !useEmail],
              onPressed: (index) {
                setState(() {
                  useEmail = index == 0;
                });
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Email'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Mobile'),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: inputController,
              keyboardType: useEmail ? TextInputType.emailAddress : TextInputType.phone,
              decoration: InputDecoration(
                labelText: useEmail ? 'Enter Email' : 'Enter Mobile Number',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleReset,
              child: Text(useEmail ? 'Send Reset Link' : 'Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}