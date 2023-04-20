import 'package:attend_book/components/custom_app_bar.dart';
import 'package:attend_book/components/scroll_notification_wrapper.dart';
import 'package:flutter/material.dart';

import '../all_class/all_class_screen.dart';
import '../day/day_screen.dart';
import '../range/range_screen.dart';
import '../settings/settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  static const route = 'dashboard-page';
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(keyString: route, title: 'Dashboard'),
      body: ScrollNotificationWrapper(
        keyString: route,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: const [
            PreferenceTitle(
              title: 'Analysis',
              hasDivider: false,
              padding: EdgeInsets.only(left: 20, top: 16, bottom: 2),
            ),
            _DestinationTile(
              icon: Icons.list_alt_rounded,
              title: 'All classes',
              route: AllClassScreen.route,
            ),
            _DestinationTile(
              icon: Icons.view_day_rounded,
              title: 'Day view',
              route: DayScreen.route,
            ),
            _DestinationTile(
              icon: Icons.date_range_rounded,
              title: 'Range view',
              route: RangeScreen.route,
            ),
            PreferenceTitle(
              title: 'Settings',
              padding: EdgeInsets.only(left: 20, top: 16, bottom: 2),
            ),
            _DestinationTile(
              icon: Icons.settings_rounded,
              title: 'Settings',
              route: SettingsScreen.route,
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  const _DestinationTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}
