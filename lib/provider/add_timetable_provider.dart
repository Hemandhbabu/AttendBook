import 'package:attend_book/helpers/notification_utils.dart';
import 'package:flutter/material.dart';

import '../convert/extension.dart';
import '../database/dao/timetable_dao.dart';
import '../database/entity/timetable.dart';
import '../helpers/type_def_utils.dart';
import '../tile/tile_callback.dart';

class AddTimetableProvider {
  final int? id;
  int subjectId;
  int? weekday;
  DateTime time;
  int duration;
  int notifyBefore;
  String? note;
  final Timetable? loadedTimetable;
  bool notify;

  bool get isNew => loadedTimetable == null;

  AddTimetableProvider({
    required this.loadedTimetable,
    required int? subjectId,
  })  : id = loadedTimetable?.tId,
        subjectId = subjectId ?? loadedTimetable?.subjectId ?? -1,
        weekday = loadedTimetable?.weekday,
        time = loadedTimetable?.time ?? DateTime(2020, 1, 1, 9, 0),
        duration = loadedTimetable?.duration ?? 60,
        note = loadedTimetable?.note,
        notifyBefore = loadedTimetable?.notifyBefore ?? 5,
        notify = loadedTimetable?.notify ?? true;

  String? validate(List<Timetable> timetables) {
    for (var element in timetables) {
      if (element.weekday == weekday && element.tId != id) {
        return _hasClass(
          element.duration,
          duration,
          element.time,
          time,
        );
      }
    }
    return null;
  }

  Future<void> save({
    required BuildContext context,
    required String name,
    required int currentTerm,
    required void Function() pop,
    required TimetableDao dao,
    required bool alwaysUse24HourFormat,
    required Reader read,
  }) async {
    if (weekday == null || weekday! < 0) {
      return;
    }
    final timetable = Timetable(
      tId: id,
      subjectId: subjectId,
      weekday: weekday!,
      timeString: time.toIso8601String(),
      duration: duration,
      notifyBefore: notifyBefore,
      note: note,
      notify: notify,
      term: currentTerm,
    );
    int newId;
    final alwaysUse24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;
    if (loadedTimetable == null) {
      newId = await dao.insertTimetable(timetable);
      MyTileCallback.showSnackbar(
          context: context, message: 'Timetable setted successfully.');
    } else if (!loadedTimetable!.isEqual(timetable)) {
      newId = timetable.tId!;
      await dao.updateTimetable(timetable);
      MyTileCallback.showSnackbar(
          context: context, message: 'Timetable updated successfully.');
    } else {
      MyTileCallback.showSnackbar(
          context: context, message: 'No changes found');
      return;
    }
    read(
      setTimetableNotificationProvider(
        subjectName: name,
        timetable: timetable.copyId(newId),
        alwaysUse24HourFormat: alwaysUse24HourFormat,
      ),
    );
    pop();
  }
}

const _errorTwo = 'You will be in another class during the picked time';

String? _hasClass(int durOne, int durTwo, DateTime one, DateTime two) {
  final diff = one.timeDifference(two);
  if (diff == 0) return 'You already have a period in the picked time.';
  if (diff.isNegative) {
    // negative means dayTwo is the big
    final secDiff = one.add(Duration(minutes: durOne)).timeDifference(two);
    return !secDiff.isNegative && secDiff != 0 ? _errorTwo : null;
  } else {
    final secDiff = one.timeDifference(two.add(Duration(minutes: durTwo)));
    return secDiff.isNegative ? _errorTwo : null;
  }
}
