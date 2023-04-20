part of 'settings_screen.dart';

class GradingSystemPreference extends ConsumerWidget {
  const GradingSystemPreference({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grade = GradingSystem.values[ref.watch(gradingSystemProvider)];
    return Tile(
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      title: 'Grading system',
      tileHeight: null,
      trailing: Text(grade.name, textAlign: TextAlign.center),
      pressAction: SheetTileActionData<GradingSystem>(
        selectedAction: grade,
        actions: gradingSystem,
        valueChanged: (context, value) =>
            ref.read(gradingSystemProvider.notifier).setInt(value.index),
      ),
    );
  }
}

class TermPreference extends ConsumerWidget {
  const TermPreference({Key? key}) : super(key: key);

  String getCurrentTermHasGreaterValue(int total, int current) {
    if (current > total) {
      return '\n\nNote : Since the total terms($total) is lesser than current '
          'term($current), the current term will be changed to $total'
          '${getTrailing(total)} term.';
    }
    return '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final term = ref.watch(totalTermPreferencesProvider);
    final message = '$term terms';
    ref.listen<int>(
      totalTermPreferencesProvider,
      (previous, next) {
        final current = ref.read(currentTermPreferencesProvider);
        if (current > next) {
          ref.read(currentTermPreferencesProvider.notifier).setInt(next);
        }
      },
    );
    return Tile(
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      title: 'Total terms',
      tileHeight: null,
      trailing: Text(message, textAlign: TextAlign.center),
      pressAction: SheetTileActionData<int>(
        selectedAction: term,
        forceFold: true,
        actions: List.generate(
          10,
          (index) => TileAction(text: '${index + 1}', value: index + 1),
        ),
        valueChanged: (context, value) => showAlertDialog(
          context: context,
          content: 'Do you want to change the total terms from $message '
              'to $value terms ?${getCurrentTermHasGreaterValue(
            value,
            ref.read(currentTermPreferencesProvider),
          )}',
          action: (context) =>
              ref.read(totalTermPreferencesProvider.notifier).setInt(value),
        ),
      ),
    );
  }
}

String getTrailing(int currentTerm) {
  switch (currentTerm) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

class CurrentTermPreference extends ConsumerWidget {
  const CurrentTermPreference({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTerm = ref.watch(currentTermPreferencesProvider);
    final message = '$currentTerm${getTrailing(currentTerm)} term';
    final totalTerm = ref.watch(totalTermPreferencesProvider);
    ref.listen<int>(
      currentTermPreferencesProvider,
      (previous, next) async {
        final alwaysUse24HourFormat =
            MediaQuery.of(context).alwaysUse24HourFormat;
        await NotificationUtils.cancelAllNotifications();
        final daily = ref.read(hasDailyNotificationPreferencesProvider);
        if (daily) ref.read(setDailyNotificationProvider);
        final subjects =
            (await ref.read(subjectDaoProvider).findAllSubjectsBackup())
                .reduceList((item) => item.term == next);
        if (subjects.isNotEmpty) {
          final timetables =
              (await ref.read(timetableDaoProvider).findAllTimetablesBackup())
                  .reduceList((item) => item.term == next);
          for (var item in timetables) {
            final subject =
                subjects.findItem((e) => e.id == item.subjectId)?.name;
            if (subject != null) {
              ref.read(
                setTimetableNotificationProvider(
                  timetable: item,
                  subjectName: subject,
                  alwaysUse24HourFormat: alwaysUse24HourFormat,
                ),
              );
            }
          }
        }
      },
    );
    return Tile(
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      title: 'Current term',
      tileHeight: null,
      trailing: Text(message, textAlign: TextAlign.center),
      pressAction: SheetTileActionData<int>(
        selectedAction: currentTerm,
        forceFold: totalTerm > 5,
        actions: List.generate(
          totalTerm,
          (index) => TileAction(text: '${index + 1}', value: index + 1),
        ),
        valueChanged: (context, value) => showAlertDialog(
          context: context,
          content: 'Do you want to change the current term from $message '
              'to $value${getTrailing(value)} term ?',
          action: (context) =>
              ref.read(currentTermPreferencesProvider.notifier).setInt(value),
        ),
      ),
    );
  }
}
