import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/config/flavor.dart';
import 'package:psgy/core/theme/app_theme.dart';
import 'package:psgy/features/pilot_demo/presentation/coach/coach_home_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/pilot_list_screen.dart';

/// Entry point RIÊNG cho demo Web (pilot_demo).
/// - KHÔNG import Isar / Firebase / Parking (tránh lỗi dart2js trên web)
/// - Chỉ chạy đúng flow Pilot Demo: User (Map → booking) / Coach (Home)
/// - Nút trên AppBar để chuyển User ⇄ Coach
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.initialize(AppFlavor.user); // TEMP: pilot demo entry không qua bootstrap, cần init flavor trước khi AppTheme dùng
  runApp(const ProviderScope(child: PilotDemoWebApp()));
}

class PilotDemoWebApp extends StatefulWidget {
  const PilotDemoWebApp({super.key});

  @override
  State<PilotDemoWebApp> createState() => _PilotDemoWebAppState();
}

class _PilotDemoWebAppState extends State<PilotDemoWebApp> {
  bool _isUser = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PSgy — Pilot Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: _isUser ? const PilotListScreen() : const CoachHomeScreen(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => setState(() => _isUser = !_isUser),
          backgroundColor: _isUser ? const Color(0xFF0D9488) : const Color(0xFF2563EB),
          icon: Icon(_isUser ? Icons.engineering : Icons.person),
          label: Text(_isUser ? 'Chuyển sang Coach' : 'Chuyển sang User'),
        ),
      ),
    );
  }
}
