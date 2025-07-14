// screens/set_new_password_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SetNewPasswordScreen extends StatefulWidget {
  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void _submitNewPassword() {
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields');
    } else if (newPassword != confirmPassword) {
      _showMessage('Passwords do not match');
    } else {
      // Simulate password reset
      _showMessage('Password changed successfully');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set New Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitNewPassword,
              child: Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }
}