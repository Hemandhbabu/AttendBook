part of 'settings_screen.dart';

class ReminderPreference extends ConsumerWidget {
  const ReminderPreference({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyNotification =
        ref.watch(hasDailyNotificationPreferencesProvider);
    ref.listen(
      setDailyNotificationProvider,
      (previous, next) => debugPrint('notification status $next'),
    );
    return SwitchTile(
      title: 'Daily reminder',
      value: dailyNotification,
      onChanged: (val) async {
        final boo = val
            ? true
            : await showAlertDialog(
                  context: context,
                  content: 'Do you want to turn off your daily reminder ?',
                ) ??
                false;
        if (boo) {
          ref
              .read(hasDailyNotificationPreferencesProvider.notifier)
              .setBool(val);
        }
      },
    );
  }
}

class ReminderTimePreference extends ConsumerWidget {
  const ReminderTimePreference({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyNotification =
        ref.watch(hasDailyNotificationPreferencesProvider);
    if (!dailyNotification) return const SizedBox.shrink();
    final dateTime = DateTime.parse(
      ref.watch(dailyNotificationTimePreferencesProvider),
    );
    return Tile(
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      title: 'Reminder time',
      tileHeight: null,
      trailing: Text(
        dateTime.timeFormat(MediaQuery.of(context).alwaysUse24HourFormat),
      ),
      onTap: () async {
        final time = await showTimePicker(
            context: context, initialTime: TimeOfDay.fromDateTime(dateTime));
        if (time != null) {
          await ref
              .read(dailyNotificationTimePreferencesProvider.notifier)
              .setString(dateTime.copyTimeOfDay(time).toIso8601String());
        }
      },
    );
  }
}
