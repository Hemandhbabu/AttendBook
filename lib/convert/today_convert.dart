import '../database/entity/period.dart';
import '../database/entity/subject.dart';
import '../database/entity/timetable.dart';

class TodayConvert {
  final List<TodayData> _list = [];
  List<TodayData> get list => [..._list];

  TodayConvert(List<Subject> subjects, List<Timetable> timetables,
      List<Period> periods) {
    _list.clear();
  }
}

class TodayData {
  final String id;
  final Period? period;
  final Timetable? timetable;
  final Subject subject;

  TodayData({
    required this.subject,
    required this.period,
    required this.timetable,
  })  : id = period == null ? 't ${timetable!.tId}' : 'p ${period.pId}',
        assert(period != null || timetable != null);
}
