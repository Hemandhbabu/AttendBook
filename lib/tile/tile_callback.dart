import 'package:attend_book/helpers/notification_utils.dart';
import 'package:flutter/material.dart';

import '../convert/extension.dart';
import '../database/entity/period.dart';
import '../database/entity/subject.dart';
import '../database/entity/timetable.dart';
import '../helpers/enums.dart';
import '../helpers/type_def_utils.dart';
import '../provider/preference_provider.dart';
import '../provider/providers.dart';
import '../screen/add_subject/add_subject_screen.dart';
import '../screen/add_timetable/add_time_table_screen.dart';
import '../screen/calendar_view/calendar_view_screen.dart';
import '../screen/grade/subject_grade_screen.dart';
import '../screen/period/period_screen.dart';
import '../screen/subject_timetable/subject_timetable_screen.dart';

class MyTileCallback {
  static Future<void> homeTodayCallback({
    required Reader read,
    required BuildContext context,
    required int subjectId,
    required PresentStatus presentStatus,
    required Timetable timetable,
  }) async {
    final periodDao = read(periodDaoProvider);
    var show = read(addConfirmPeriodProvider);
    final boo = show
        ? await showAlertDialog(
            context: context,
            showTitle: false,
            content: _periodChangeText(presentStatus),
          )
        : true;
    if (boo == true) {
      final period = Period(
        pId: null,
        subjectId: subjectId,
        dateTimeString: DateTime.now()
            .copyTimeOfDay(TimeOfDay.fromDateTime(timetable.time))
            .toIso8601String(),
        duration: timetable.duration,
        statusIndex: presentStatus.index,
        timetableId: timetable.tId!,
        term: read(currentTermPreferencesProvider),
      );
      periodDao.insertPeriod(period);
    }
  }

  static void periodPressCallback({
    required Reader read,
    required BuildContext context,
    required TilePressActionsEnum press,
    required int subjectId,
    required Period? period,
  }) {
    switch (press) {
      case TilePressActionsEnum.calendarView:
        Navigator.pushNamed(context, CalendarViewScreen.route,
            arguments: subjectId);
        break;
      case TilePressActionsEnum.delete:
        if (period != null) {
          periodDeleteDialog(
            read: read,
            context: context,
            period: period,
          );
        }
        break;
      case TilePressActionsEnum.edit:
      case TilePressActionsEnum.reset:
      case TilePressActionsEnum.done:
      case TilePressActionsEnum.undo:
      case TilePressActionsEnum.notify:
      case TilePressActionsEnum.unNotify:
        break;
    }
  }

  static Future<void> periodChangeCallback({
    required Reader read,
    required BuildContext context,
    required Period period,
    required PresentStatus status,
  }) async {
    if (period.status == status) return;
    final show = read(changeConfirmPeriodProvider);
    final boo = show
        ? await showAlertDialog(
            context: context,
            showTitle: false,
            content: _periodChangeText(period.status, status),
          )
        : true;
    if (boo == true) {
      read(periodDaoProvider)
          .updatePeriod(period.changePresentStatus(status.index));
    }
  }

  static Future<bool> periodDeleteDialog({
    required Reader read,
    required BuildContext context,
    required Period period,
  }) async {
    final show = read(deleteConfirmPeriodProvider);
    final boo = show
        ? await showAlertDialog(
            context: context,
            content: 'Do you want to remove this period permanently ?',
          )
        : true;
    if (boo == true) {
      final periodDao = read(periodDaoProvider);
      await periodDao.deletePeriod(period);
      return true;
    }
    return false;
  }

  static void subjectMoreCallback({
    required Reader read,
    required BuildContext context,
    required TilePressActionsEnum moreEnum,
    required Subject subject,
  }) {
    switch (moreEnum) {
      case TilePressActionsEnum.edit:
        Navigator.of(context)
            .pushNamed(AddSubjectScreen.route, arguments: subject);
        break;
      case TilePressActionsEnum.reset:
        showAlertDialog(
          context: context,
          content: 'Do you want to reset the attendance record of '
              '${subject.name} ?\n\nNote : All classes will be deleted.',
          action: (context) async {
            final dao = read(periodDaoProvider);
            final periods =
                (await dao.findAllPeriods(read(currentTermPreferencesProvider)))
                    .reduceList((data) => data.subjectId == subject.id);
            await dao.deletePeriods(periods);
          },
        );
        break;
      case TilePressActionsEnum.delete:
        showAlertDialog(
          context: context,
          content: 'Do you want to delete ${subject.name} ?\n\nNote : All '
              'chapters, notes, classes and timetable data will be deleted.',
          action: (context) async {
            final subjectDao = read(subjectDaoProvider);
            await subjectDao.deleteSubject(subject);

            final term = read(currentTermPreferencesProvider);

            final periodDao = read(periodDaoProvider);
            final periods = (await periodDao.findAllPeriods(term))
                .reduceList((data) => data.subjectId == subject.id);
            await periodDao.deletePeriods(periods);

            final gradeDao = read(gradeDaoProvider);
            final grades = (await gradeDao.findAllGrades(term))
                .reduceList((item) => item.subjectId == subject.id);
            await gradeDao.deleteGrades(grades);

            final timetableDao = read(timetableDaoProvider);
            final timetables = (await timetableDao.findAllTimetables(term))
                .reduceList((data) => data.subjectId == subject.id);
            await timetableDao.deleteTimetables(timetables);

            for (var item in timetables) {
              read(
                setTimetableNotificationProvider(
                  alwaysUse24HourFormat: false,
                  timetable: item.setNotify(false),
                  subjectName: '',
                ),
              );
            }

            showSnackbar(
              context: context,
              message: 'Subject deleted.',
              action: () => subjectDao.insertSubject(subject),
            );
          },
        );
        break;
      case TilePressActionsEnum.calendarView:
      case TilePressActionsEnum.done:
      case TilePressActionsEnum.undo:
      case TilePressActionsEnum.notify:
      case TilePressActionsEnum.unNotify:
        break;
    }
  }

  static void subjectCallback(
    BuildContext context,
    SubjectTileEnum tileEnum,
    Subject subject,
  ) {
    switch (tileEnum) {
      case SubjectTileEnum.period:
        Navigator.of(context)
            .pushNamed(PeriodScreen.route, arguments: subject.id);
        break;
      case SubjectTileEnum.timetable:
        Navigator.of(context)
            .pushNamed(SubjectTimetableScreen.route, arguments: subject.id);
        break;
      case SubjectTileEnum.grades:
        Navigator.of(context)
            .pushNamed(SubjectGradeScreen.route, arguments: subject);
        break;
    }
  }

  static void showSnackbar({
    required BuildContext context,
    required String message,
    String actionString = 'Undo',
    VoidCallback? action,
    Duration duration = const Duration(seconds: 2),
  }) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.removeCurrentSnackBar();
    scaffold.showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(fontFamily: 'VarelaRound')),
      duration: duration,
      action: action == null
          ? null
          : SnackBarAction(label: actionString, onPressed: action),
    ));
  }

  static Future<void> timetableCallback({
    required BuildContext context,
    required Reader read,
    required TilePressActionsEnum val,
    required String name,
    required Timetable timetable,
  }) async {
    switch (val) {
      case TilePressActionsEnum.edit:
        Navigator.pushNamed(context, AddTimetableScreen.route,
            arguments: AddTimetableArg(timetable: timetable));
        break;
      case TilePressActionsEnum.delete:
        showAlertDialog(
          context: context,
          content: 'Do you want to remove this class from timetable ?',
          action: (context) async {
            final timetableDao = read(timetableDaoProvider);
            await timetableDao.deleteTimetable(timetable);
            read(
              setTimetableNotificationProvider(
                alwaysUse24HourFormat: false,
                timetable: timetable.setNotify(false),
                subjectName: '',
              ),
            );
            showSnackbar(context: context, message: 'Timetable deleted.');
          },
        );
        break;
      case TilePressActionsEnum.notify:
        timetable = timetable.setNotify(true);
        read(
          setTimetableNotificationProvider(
            alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
            timetable: timetable.setNotify(true),
            subjectName: name,
          ),
        );
        await read(timetableDaoProvider).updateTimetable(timetable);
        break;
      case TilePressActionsEnum.unNotify:
        showAlertDialog(
          context: context,
          content: 'Do you want to turn off notification for this class ?',
          action: (context) async {
            read(
              setTimetableNotificationProvider(
                alwaysUse24HourFormat: false,
                timetable: timetable.setNotify(false),
                subjectName: '',
              ),
            );
            await read(timetableDaoProvider)
                .updateTimetable(timetable.setNotify(false));
            showSnackbar(
              context: context,
              message: 'Notification turned off for this timetable.',
            );
          },
        );
        break;
      case TilePressActionsEnum.reset:
      case TilePressActionsEnum.calendarView:
      case TilePressActionsEnum.done:
      case TilePressActionsEnum.undo:
        break;
    }
  }
}

Future<bool?> showAlertDialog({
  required BuildContext context,
  required String content,
  String negativeText = 'No',
  String positiveText = 'Yes',
  String title = 'Are you sure ?',
  bool showTitle = true,
  ValueChanged<BuildContext>? action,
  String? route,
  dynamic arguments,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: showTitle ? Text(title, textAlign: TextAlign.center) : null,
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(negativeText),
        ),
        TextButton(
          onPressed: () {
            action?.call(context);
            if (route == null) {
              Navigator.pop(context, true);
            } else {
              Navigator.popAndPushNamed(context, route,
                  result: true, arguments: arguments);
            }
          },
          child: Text(positiveText),
        ),
      ],
    ),
  );
}

String presentStatusString(PresentStatus presentStatus) {
  switch (presentStatus) {
    case PresentStatus.present:
      return 'Present';
    case PresentStatus.absent:
      return 'Absent';
    case PresentStatus.cancel:
      return 'Cancel';
  }
}

String _periodChangeText(PresentStatus one, [PresentStatus? two]) {
  return 'Do you want to ${two == null ? 'mark the period as '
      '${presentStatusString(one)} ?' : 'change this period from '
      '${presentStatusString(one)} to ${presentStatusString(two)} ?'}';
}
