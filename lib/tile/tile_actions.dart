part of 'tile.dart';

const presentStatusActions = [
  TileAction(
    icon: Icons.done_rounded,
    text: 'Present',
    color: Colors.green,
    value: PresentStatus.present,
  ),
  TileAction(
    icon: Icons.close_rounded,
    text: 'Absent',
    color: Colors.red,
    value: PresentStatus.absent,
  ),
  TileAction(
    icon: Icons.remove_rounded,
    text: 'Cancel',
    color: Colors.orange,
    value: PresentStatus.cancel,
  ),
];
const subjectActions = [
  TileAction(
    icon: Icons.list_alt_rounded,
    text: 'Periods',
    value: SubjectTileEnum.period,
  ),
  TileAction(
    icon: Icons.table_view_rounded,
    text: 'Timatables',
    value: SubjectTileEnum.timetable,
  ),
  TileAction(
    icon: Icons.grade_rounded,
    text: 'Grades',
    value: SubjectTileEnum.grades,
  ),
];
const calendarAction = TileAction(
  icon: Icons.calendar_today_rounded,
  text: 'Calendar view',
  value: TilePressActionsEnum.calendarView,
);
const editAction = TileAction(
  icon: Icons.edit_rounded,
  text: 'Edit',
  color: Colors.blue,
  value: TilePressActionsEnum.edit,
);
const resetAction = TileAction(
  icon: Icons.refresh_rounded,
  text: 'Reset',
  color: Colors.orange,
  value: TilePressActionsEnum.reset,
);
const deleteAction = TileAction(
  icon: Icons.delete_rounded,
  text: 'Delete',
  color: Colors.red,
  value: TilePressActionsEnum.delete,
);
const notifyAction = TileAction(
  icon: Icons.alarm_rounded,
  text: 'Turn on notification',
  value: TilePressActionsEnum.notify,
  color: Colors.green,
);
const unNotifyAction = TileAction(
  icon: Icons.alarm_off_rounded,
  text: 'Turn off notification',
  value: TilePressActionsEnum.unNotify,
  color: Colors.blueGrey,
);
const doneAction = TileAction(
  icon: Icons.done_rounded,
  text: 'Mark as done',
  value: TilePressActionsEnum.done,
  color: Colors.green,
);
const undoAction = TileAction(
  icon: Icons.undo_rounded,
  text: 'Undo mark',
  value: TilePressActionsEnum.undo,
  color: Colors.blueGrey,
);
const themeActions = [
  TileAction(text: 'System default', value: ThemeMode.system),
  TileAction(text: 'Light', value: ThemeMode.light),
  TileAction(text: 'Dark', value: ThemeMode.dark),
];
const gradingSystem = [
  TileAction(text: 'Numeric from 0 to 5', value: GradingSystem.zeroToFive),
  TileAction(text: 'Numeric from 0 to 10', value: GradingSystem.zeroToTen),
  TileAction(text: 'Numeric from 0 to 100', value: GradingSystem.zeroToHundred),
];
const reminderFrequencyActions = [
  TileAction(text: 'Once', value: ReminderFrequency.once),
  TileAction(text: 'Daily', value: ReminderFrequency.daily),
  TileAction(text: 'Weekly', value: ReminderFrequency.weekly),
  TileAction(text: 'Monthly', value: ReminderFrequency.monthly),
];

/// Only [LockScreenEnum.change] and [LockScreenEnum.off]
/// is used as lock screen actions others are not considered
const lockScreenActions = [
  TileAction(text: 'Change PIN', value: LockScreenEnum.change),
  TileAction(text: 'Turn off', value: LockScreenEnum.off),
];
