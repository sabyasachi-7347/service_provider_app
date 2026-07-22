// widgets/otp_dialog.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OtpDialog extends StatefulWidget {
  final String mobile;
  final VoidCallback onVerified;

  const OtpDialog({super.key, required this.mobile, required this.onVerified});

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  final TextEditingController otpController = TextEditingController();
  bool _isSending = true;
  bool _isVerifying = false;
  String? _errorMessage;
  String? _devOtpHint;

  @override
  void initState() {
    super.initState();
    _sendOtp();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService.sendOtp(widget.mobile);
      if (!mounted) return;
      setState(() {
        _isSending = false;
        // No SMS gateway configured yet — the backend hands back the code so
        // this demo flow stays testable without a real phone.
        _devOtpHint = response['otp']?.toString();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
        _errorMessage = 'Failed to send OTP: ${e.toString()}';
      });
    }
  }

  Future<void> _verifyOtp() async {
    if (otpController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Enter the OTP sent to your mobile');
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      await ApiService.verifyOtp(
        mobile: widget.mobile,
        otp: otpController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onVerified();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter OTP'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('A verification code was sent to ${widget.mobile}'),
          if (_devOtpHint != null) ...[
            const SizedBox(height: 6),
            Text(
              'Demo OTP: $_devOtpHint',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            enabled: !_isSending && !_isVerifying,
            decoration: const InputDecoration(hintText: '4-digit OTP'),
            maxLength: 4,
          ),
          if (_isSending)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Sending OTP...'),
                ],
              ),
            ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          if (!_isSending)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _sendOtp,
                child: const Text('Resend OTP'),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSending || _isVerifying ? null : _verifyOtp,
          child: Text(_isVerifying ? 'Verifying...' : 'Verify'),
        ),
      ],
    );
  }
}
