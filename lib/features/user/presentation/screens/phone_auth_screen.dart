import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/features/user/presentation/providers/user_profile_provider.dart';

class PhoneAuthScreen extends ConsumerStatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  ConsumerState<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends ConsumerState<PhoneAuthScreen> {
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

  void _showErrorIfNeeded(UserProfileState profileState) {
    final error = profileState.error;
    if (error == null || error.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red.shade700,
        ),
      );
    });
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số điện thoại hợp lệ')),
      );
      return;
    }
    _lastPhone = phone;
    await ref.read(userProfileProvider.notifier).sendOtp(phone);
    final state = ref.read(userProfileProvider).value;
    if (state?.otpSent == true && mounted) {
      setState(() => _otpStep = true);
      _startResendCountdown();
    }
  }

  Future<void> _verifyOtp() async {
    final code = _otpController.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mã OTP phải có 6 chữ số')),
      );
      return;
    }
    final ok = await ref.read(userProfileProvider.notifier).verifyOtp(code);
    if (ok && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final profileState = profileAsync.value ?? const UserProfileState();
    _showErrorIfNeeded(profileState);

    return Scaffold(
      appBar: AppBar(
        title: Text(_otpStep ? 'Nhập mã xác thực' : 'Xác thực số điện thoại'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _otpStep ? _buildOtpStep(profileState) : _buildPhoneStep(profileState),
      ),
    );
  }

  Widget _buildPhoneStep(UserProfileState profileState) {
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
          onPressed: profileState.isLoading ? null : _sendOtp,
          child: profileState.isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Gửi mã OTP'),
        ),
      ],
    );
  }

  Widget _buildOtpStep(UserProfileState profileState) {
    final maskedPhone = _lastPhone != null ? '+84${_lastPhone!.replaceFirst('0', '')}' : '';

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
          onPressed: profileState.isLoading ? null : _verifyOtp,
          child: profileState.isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Xác nhận'),
        ),
        const SizedBox(height: 16),
        if (_resendSeconds > 0)
          Text(
            'Gửi lại sau $_resendSeconds giây',
            textAlign: TextAlign.center,
          )
        else
          TextButton(
            onPressed: profileState.isLoading
                ? null
                : () async {
                    if (_lastPhone != null) {
                      await ref
                          .read(userProfileProvider.notifier)
                          .sendOtp(_lastPhone!);
                      _startResendCountdown();
                    }
                  },
            child: const Text('Gửi lại OTP'),
          ),
      ],
    );
  }
}
