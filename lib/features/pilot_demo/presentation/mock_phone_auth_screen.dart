import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psgy/features/pilot_demo/data/mock_user_session.dart';

/// TEMP: pilot demo OTP — no Firebase. Real flow remains in PhoneAuthScreen.
class MockPhoneAuthScreen extends StatefulWidget {
  const MockPhoneAuthScreen({super.key, this.onVerified});

  final VoidCallback? onVerified;

  @override
  State<MockPhoneAuthScreen> createState() => _MockPhoneAuthScreenState();
}

class _MockPhoneAuthScreenState extends State<MockPhoneAuthScreen> {
  static const _demoCodeHint = '123456';

  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  int _resendSeconds = 0;
  Timer? _resendTimer;
  bool _otpStep = false;
  String? _lastPhone;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = 60);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendSeconds <= 1) {
        setState(() => _resendSeconds = 0);
        timer.cancel();
      } else {
        setState(() => _resendSeconds -= 1);
      }
    });
  }

  void _showDemoCodeSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mã demo: $_demoCodeHint')),
    );
  }

  void _sendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số điện thoại hợp lệ')),
      );
      return;
    }
    _lastPhone = phone;
    setState(() => _otpStep = true);
    _startResendCountdown();
    _showDemoCodeSnackBar();
  }

  void _resendOtp() {
    if (_lastPhone == null) return;
    _startResendCountdown();
    _showDemoCodeSnackBar();
  }

  void _verifyOtp() {
    final code = _otpController.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mã OTP phải có 6 chữ số')),
      );
      return;
    }
    MockUserSession.instance.rememberVerifiedPhone(_lastPhone);
    widget.onVerified?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_otpStep ? 'Nhập mã xác thực' : 'Xác thực số điện thoại'),
        automaticallyImplyLeading: widget.onVerified == null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _otpStep ? _buildOtpStep() : _buildPhoneStep(),
      ),
    );
  }

  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Nhập số điện thoại để tiếp tục'),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 10,
          decoration: const InputDecoration(
            hintText: '09x xxx xxxx',
            counterText: '',
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _sendOtp,
          child: const Text('Gửi mã OTP'),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    final maskedPhone =
        _lastPhone != null ? '+84${_lastPhone!.replaceFirst('0', '')}' : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Mã OTP đã gửi đến $maskedPhone'),
        const SizedBox(height: 16),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(fontSize: 24, letterSpacing: 8),
          decoration: const InputDecoration(
            hintText: '000000',
            counterText: '',
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _verifyOtp,
          child: const Text('Xác nhận'),
        ),
        const SizedBox(height: 16),
        if (_resendSeconds > 0)
          Text(
            'Gửi lại sau $_resendSeconds giây',
            textAlign: TextAlign.center,
          )
        else
          TextButton(
            onPressed: _resendOtp,
            child: const Text('Gửi lại OTP'),
          ),
      ],
    );
  }
}
