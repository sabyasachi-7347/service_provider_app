// screens/otp_dialog.dart
import 'package:flutter/material.dart';

class OtpDialog extends StatefulWidget {
  final VoidCallback onVerified;

  OtpDialog({required this.onVerified});

  @override
  _OtpDialogState createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  final TextEditingController otpController = TextEditingController();

  void _verifyOtp() {
    // Simulate OTP verification
    if (otpController.text == '123456') {
      Navigator.of(context).pop(); // Close dialog
      widget.onVerified(); // Call success callback
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter OTP'),
      content: TextField(
        controller: otpController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: '6-digit OTP'),
        maxLength: 6,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _verifyOtp,
          child: Text('Verify'),
        ),
      ],
    );
  }
}
