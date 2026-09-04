import 'package:flutter/material.dart';
import 'package:psgy/features/pilot_demo/presentation/community_feed_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/my_journal_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/pilot_map_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/user_booking_history_screen.dart';

class MainShellScreen extends StatefulWidget {
  static const routeName = 'main_shell';

  const MainShellScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const MainShellScreen(),
    );
  }

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _index = 0;

  final _tabs = const <Widget>[
    PilotMapScreen(),
    MyJournalScreen(),
    CommunityFeedScreen(),
    UserBookingHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _index,
        children: _tabs,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        selectedIndex: _index,
        onDestinationSelected: (index) {
          setState(() => _index = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Bản đồ',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: 'Nhật ký',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Cộng đồng',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Lịch sử',
          ),
        ],
      ),
    );
  }
}
