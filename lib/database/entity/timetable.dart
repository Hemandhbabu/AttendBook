import 'package:floor/floor.dart';

@entity
class Timetable {
  @PrimaryKey(autoGenerate: true)
  final int? tId;
  final int subjectId;
  final int weekday;
  final String timeString;
  final int duration;
  final int notifyBefore;
  final String? note;
  final int term;
  final bool notify;

  DateTime get time => DateTime.parse(timeString);

  const Timetable({
    required this.tId,
    required this.weekday,
    required this.subjectId,
    required this.timeString,
    required this.duration,
    required this.notifyBefore,
    required this.note,
    required this.term,
    required this.notify,
  });

  Map<String, dynamic> toMap() => {
        'tId': tId,
        'weekday': weekday,
        'subjectId': subjectId,
        'timeString': timeString,
        'duration': duration,
        'note': note,
        'term': term,
        'notifyBefore': notifyBefore,
        'notify': notify,
      };

  Timetable.fromMap(Map<String, dynamic> map)
      : tId = map['tId'],
        weekday = map['weekday'],
        subjectId = map['subjectId'],
        timeString = map['timeString'],
        duration = map['duration'],
        notifyBefore = map['notifyBefore'] ?? 5,
        term = map['term'],
        note = map['note'],
        notify = map['notify'] ?? true;

  Timetable copyId(int id) => Timetable(
        tId: id,
        weekday: weekday,
        subjectId: subjectId,
        timeString: timeString,
        duration: duration,
        note: note,
        notifyBefore: notifyBefore,
        term: term,
        notify: notify,
      );

  Timetable setNotify(bool notify) => Timetable(
        tId: tId,
        weekday: weekday,
        subjectId: subjectId,
        timeString: timeString,
        duration: duration,
        note: note,
        notifyBefore: notifyBefore,
        term: term,
        notify: notify,
      );

  bool isEqual(Timetable value) =>
      tId == value.tId &&
      subjectId == value.subjectId &&
      weekday == value.weekday &&
      timeString == value.timeString &&
      duration == value.duration &&
      term == value.term &&
      notifyBefore == value.notifyBefore &&
      notify == value.notify &&
      note == value.note;
}
