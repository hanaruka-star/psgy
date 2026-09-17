import 'package:flutter/material.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/core/theme/app_status_colors.dart';
import 'package:psgy/features/pilot_demo/presentation/community_feed_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/my_journal_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/pilot_map_screen.dart';
import 'package:psgy/features/pilot_demo/presentation/pt_ai/pt_ai_intro_screen.dart';
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

  void _openPtAi() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PtAiIntroScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _index,
        children: _tabs,
      ),
      bottomNavigationBar: _UserNavBar(
        index: _index,
        onSelect: (index) => setState(() => _index = index),
        onPtAi: _openPtAi,
      ),
    );
  }
}

class _UserNavBar extends StatelessWidget {
  const _UserNavBar({
    required this.index,
    required this.onSelect,
    required this.onPtAi,
  });

  static const _barHeight = 64.0;
  static const _fabLift = 16.0;

  final int index;
  final ValueChanged<int> onSelect;
  final VoidCallback onPtAi;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SizedBox(
      height: _barHeight + bottom + _fabLift,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              color: theme.colorScheme.surface,
              elevation: 3,
              shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.2),
              child: Padding(
                padding: EdgeInsets.only(bottom: bottom),
                child: SizedBox(
                  height: _barHeight,
                  child: Row(
                    children: [
                      Expanded(
                        child: _NavItem(
                          icon: Icons.map_outlined,
                          selectedIcon: Icons.map,
                          label: 'Bản đồ',
                          selected: index == 0,
                          onTap: () => onSelect(0),
                        ),
                      ),
                      Expanded(
                        child: _NavItem(
                          icon: Icons.auto_stories_outlined,
                          selectedIcon: Icons.auto_stories,
                          label: 'Nhật ký',
                          selected: index == 1,
                          onTap: () => onSelect(1),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Expanded(
                        child: _NavItem(
                          icon: Icons.groups_outlined,
                          selectedIcon: Icons.groups,
                          label: 'Cộng đồng',
                          selected: index == 2,
                          onTap: () => onSelect(2),
                        ),
                      ),
                      Expanded(
                        child: _NavItem(
                          icon: Icons.receipt_long_outlined,
                          selectedIcon: Icons.receipt_long,
                          label: 'Lịch sử',
                          selected: index == 3,
                          onTap: () => onSelect(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: bottom + 6,
            child: Center(
              child: _PtAiNavButton(onPressed: onPtAi),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected
        ? AppStatusColors.tabActive(theme.brightness)
        : AppStatusColors.tabInactive;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(selected ? selectedIcon : icon, color: color, size: 24),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _PtAiNavButton extends StatelessWidget {
  const _PtAiNavButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    return Semantics(
      button: true,
      label: 'PT AI',
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              key: const Key('nav_pt_ai'),
              elevation: 4,
              shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.35),
              shape: const CircleBorder(),
              color: AppStatusColors.highlight(brightness),
              child: SizedBox(
                width: 60,
                height: 60,
                child: Icon(
                  Icons.videocam_outlined,
                  size: 30,
                  color: AppStatusColors.onHighlight(brightness),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'PT AI',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppStatusColors.tabActive(brightness),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
