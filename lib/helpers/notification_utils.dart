// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:attend_book/convert/extension.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

import '../database/entity/timetable.dart';
import '../provider/preference_provider.dart';

part 'notification_utils.g.dart';

late final FlutterLocalNotificationsPlugin _plugin;

void initializeNotification(FlutterLocalNotificationsPlugin plugin) {
  _plugin = plugin;
}

final setDailyNotificationProvider = FutureProvider.autoDispose(
  (ref) async {
    final hasNotification = ref.watch(hasDailyNotificationPreferencesProvider);
    final time = DateTime.parse(
      ref.watch(dailyNotificationTimePreferencesProvider),
    );
    if (hasNotification) {
      await _setDailyNotification(time.hour, time.minute, _plugin);
      return true;
    } else {
      await _cancelDailyNotification(_plugin);
      return false;
    }
  },
);

@riverpod
Future<bool> setTimetableNotification(
  SetTimetableNotificationRef ref, {
  required String subjectName,
  required Timetable timetable,
  required bool alwaysUse24HourFormat,
}) async {
  if (timetable.notify) {
    await _setTimetableNotification(
      timetable: timetable,
      subjectName: subjectName,
      alwaysUse24HourFormat: alwaysUse24HourFormat,
      plugin: _plugin,
    );
    return true;
  } else {
    await _cancelTimetableNotification(timetable.tId!, _plugin);
    return false;
  }
}

const _DAILY_NOTIFICATION_ID = 546;
const _DAILY_NOTIFICATION_CHANNEL_ID = "Daily-Reminder";
const _TIMETABLE_NOTIFICATION_CHANNEL_ID = "Classes";

Future<void> _setDailyNotification(
  int hour,
  int minute,
  FlutterLocalNotificationsPlugin plugin,
) =>
    _buildRepeatingNotification(
      id: _DAILY_NOTIFICATION_ID,
      dateTime: _nextInstanceOfTime(hour, minute),
      title: 'Reminder',
      content: 'Don\'t forgot to add your daily transactions',
      bigText:
          'Don\'t forgot to add your daily transactions to manage your budget on track',
      channelId: _DAILY_NOTIFICATION_CHANNEL_ID,
      channelName: 'Daily reminder',
      dateTimeComponents: DateTimeComponents.time,
      plugin: plugin,
      tag: _DAILY_NOTIFICATION_CHANNEL_ID,
    );

Future<void> _buildRepeatingNotification({
  required int id,
  required String title,
  required String content,
  String? bigText,
  required String channelId,
  required String channelName,
  String? channelDescription,
  required DateTimeComponents dateTimeComponents,
  required tz.TZDateTime dateTime,
  String? payload,
  required String tag,
  required FlutterLocalNotificationsPlugin plugin,
}) async {
  final bigTextStyleInformation = bigText == null
      ? null
      : BigTextStyleInformation(bigText, contentTitle: title);
  final platformChannelSpecifics = NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      styleInformation: bigTextStyleInformation,
      importance: Importance.max,
      priority: Priority.high,
      tag: tag,
    ),
  );
  await plugin.zonedSchedule(
    id,
    title,
    content,
    dateTime,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: dateTimeComponents,
    payload: payload,
  );
}

tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute, 0);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

tz.TZDateTime _nextInstanceOfWeekAndTime(int hour, int minute, int weekday) {
  tz.TZDateTime scheduledDate = _nextInstanceOfTime(hour, minute);
  while (scheduledDate.weekday != weekday) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

Future<void> _cancelDailyNotification(FlutterLocalNotificationsPlugin plugin) =>
    plugin.cancel(_DAILY_NOTIFICATION_ID);

Future<void> _setTimetableNotification({
  required Timetable timetable,
  required String subjectName,
  required bool alwaysUse24HourFormat,
  required FlutterLocalNotificationsPlugin plugin,
}) {
  if (timetable.notify) {
    return _buildRepeatingNotification(
      id: timetable.tId!,
      title: 'Class Reminder',
      tag: _TIMETABLE_NOTIFICATION_CHANNEL_ID,
      content:
          '$subjectName class at ${timetable.time.timeFormat(alwaysUse24HourFormat)}',
      bigText:
          'You have $subjectName class at ${timetable.time.timeFormat(alwaysUse24HourFormat)} for ${timetable.duration} minutes',
      channelId: _TIMETABLE_NOTIFICATION_CHANNEL_ID,
      channelName: 'Timetable reminder',
      dateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      plugin: plugin,
      payload: json.encode(<String>['timetable', '${timetable.tId!}']),
      dateTime: _nextInstanceOfWeekAndTime(
          timetable.time.hour,
          timetable.time.minute - timetable.notifyBefore,
          timetable.weekday + 1),
    );
  } else {
    return Future.value(null);
  }
}

Future<void> _cancelTimetableNotification(
        int id, FlutterLocalNotificationsPlugin plugin) =>
    plugin.cancel(id, tag: _TIMETABLE_NOTIFICATION_CHANNEL_ID);

class NotificationUtils {
  const NotificationUtils._();
  static Future<void> cancelAllNotifications() => _plugin.cancelAll();
}
