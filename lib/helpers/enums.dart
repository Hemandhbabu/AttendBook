import 'package:flutter/material.dart';

enum PresentStatus { present, absent, cancel }

enum SubjectTileEnum { timetable, period, grades }

enum LockScreenEnum { set, change, off, security, verify, confirm }

enum GradingSystem {
  zeroToFive(5, 'Numeric from 0 to 5'),
  zeroToTen(10, 'Numeric from 0 to 10'),
  zeroToHundred(100, 'Numeric from 0 to 100');

  final int value;
  final String name;
  const GradingSystem(this.value, this.name);
}

enum ReminderFrequency { once, daily, weekly, monthly }

enum TilePressActionsEnum {
  edit,
  reset,
  delete,
  calendarView,
  done,
  undo,
  notify,
  unNotify,
}

enum ThemeColors {
  red(Colors.red),
  purple(Colors.purple),
  indigo(Colors.indigo),
  blue(Colors.blue),
  cyan(Colors.cyan),
  teal(Colors.teal),
  green(Colors.green),
  lime(Colors.lime),
  amber(Colors.amber),
  orange(Colors.orange),
  brown(Colors.brown),
  blueGrey(Colors.blueGrey);

  final MaterialColor color;

  const ThemeColors(this.color);
}
