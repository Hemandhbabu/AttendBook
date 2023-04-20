import 'package:attend_book/main.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../app_lock_package/app_lock.dart';
import '../../components/custom_app_bar.dart';
import '../../components/scroll_notification_wrapper.dart';
import '../../convert/extension.dart';
import '../../helpers/enums.dart';
import '../../helpers/notification_utils.dart';
import '../../provider/preference_provider.dart';
import '../../provider/providers.dart';
import '../../tile/switch_tile.dart';
import '../../tile/tile.dart';
import '../../tile/tile_callback.dart';
import 'all_term_grade.dart';
import 'backup.dart';

part 'appearance.dart';
part 'attendance.dart';
part 'confirm_actions.dart';
part 'reminder.dart';
part 'security.dart';

class SettingsScreen extends StatelessWidget {
  static const route = 'settings-screen';
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings', keyString: route),
      body: ScrollNotificationWrapper(
        keyString: route,
        child: ListView(
          children: const [
            PreferenceTitle(title: 'Appearance', hasDivider: false),
            SystemModePreference(),
            UseAndroid12Preference(),
            ThemeColorPreference(),
            PreferenceTitle(title: 'Terms & Grading'),
            TermPreference(),
            CurrentTermPreference(),
            GradingSystemPreference(),
            AllTermGradeTile(),
            PreferenceTitle(title: 'Security'),
            LockScreenPreference(),
            FingerprintPreference(),
            LockScreenTimeoutPreference(),
            SecurityQuestionPreference(),
            PreferenceTitle(title: 'Backup and Restore'),
            BackupPreference(),
            RestorePreference(),
            PreferenceTitle(title: 'Notification'),
            ReminderPreference(),
            ReminderTimePreference(),
            PreferenceTitle(title: 'Period action confirmations'),
            PeriodAddConfirm(),
            PeriodChangeConfirm(),
            PeriodDeleteConfirm(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class PreferenceTitle extends StatelessWidget {
  const PreferenceTitle({
    Key? key,
    required this.title,
    this.hasDivider = true,
    this.padding = const EdgeInsets.only(top: 16, left: 16),
    this.fontSize = 14,
  }) : super(key: key);
  final String title;
  final double fontSize;
  final bool hasDivider;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasDivider) const Divider(indent: 20, endIndent: 20),
        Padding(
          padding: padding,
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: Curves.decelerate)),
      child: child,
    );
  }
}
