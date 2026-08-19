import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppMode {
  user,
  staff,
}

// Bien toan cuc de switch mode de dang
class AppModeController extends ChangeNotifier {
  AppMode _currentMode = AppMode.user;

  AppMode get currentMode => _currentMode;

  void switchToUser() {
    _currentMode = AppMode.user;
    notifyListeners();
  }

  void switchToStaff() {
    _currentMode = AppMode.staff;
    notifyListeners();
  }

  bool get isUser => _currentMode == AppMode.user;
  bool get isStaff => _currentMode == AppMode.staff;
}

// Provider don gian (se dung Riverpod sau)
final appModeController = AppModeController();

final appModeProvider = ChangeNotifierProvider<AppModeController>((ref) {
  return AppModeController();
});
