import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../convert/extension.dart';
import '../database/entity/grade.dart';
import '../database/entity/period.dart';
import '../database/entity/subject.dart';
import '../database/entity/timetable.dart';
import '../helpers/notification_selection_actions.dart';
import '../main.dart';
import '../models/grade_data.dart';
import '../models/subject_data.dart';
import 'preference_provider.dart';

final payloadProvider =
    StateNotifierProvider<NotificationSelectionActions, String?>(
  (ref) => NotificationSelectionActions(),
);
final subjectDaoProvider = Provider(
  (ref) => ref.watch(databaseProvider.select((value) => value.subjectDao)),
);
final timetableDaoProvider = Provider(
  (ref) => ref.watch(databaseProvider.select((value) => value.timetableDao)),
);
final gradeDaoProvider = Provider(
  (ref) => ref.watch(databaseProvider.select((value) => value.gradeDao)),
);
final periodDaoProvider = Provider(
  (ref) => ref.watch(databaseProvider.select((value) => value.periodDao)),
);
final _subjectsProvider = StreamProvider(
  (ref) => ref.watch(subjectDaoProvider).findAllSubjectsAsStream(
        ref.watch(currentTermPreferencesProvider),
      ),
);
final subjectsProvider = Provider<List<Subject>>(
  (ref) => ref.watch(_subjectsProvider).when(
        data: (data) => data,
        error: (_, __) => [],
        loading: () => [],
      ),
);
final _timetablesProvider = StreamProvider<List<Timetable>>(
  (ref) => ref.watch(timetableDaoProvider).findAllTimeTablesAsStream(
        ref.watch(currentTermPreferencesProvider),
      ),
);
final timetablesProvider = Provider<List<Timetable>>(
  (ref) => ref.watch(_timetablesProvider).when(
        data: (data) => data,
        error: (_, __) => [],
        loading: () => [],
      ),
);
final _gradesProvider = StreamProvider<List<Grade>>(
  (ref) => ref.watch(gradeDaoProvider).findAllGradesAsStream(
        ref.watch(currentTermPreferencesProvider),
      ),
);
final gradesProvider = Provider<List<Grade>>(
  (ref) => ref.watch(_gradesProvider).when(
        data: (data) => data,
        error: (_, __) => [],
        loading: () => [],
      ),
);
final _periodsProvider = StreamProvider<List<Period>>(
  (ref) => ref.watch(periodDaoProvider).findAllPeriodsAsStream(
        ref.watch(currentTermPreferencesProvider),
      ),
);
final periodsProvider = Provider<List<Period>>(
  (ref) => ref.watch(_periodsProvider).when(
        data: (data) => data,
        error: (_, __) => [],
        loading: () => [],
      ),
);
final subjectDataProvider = Provider<List<SubjectData>>((ref) {
  final subjects = ref.watch(subjectsProvider);
  final grades = ref.watch(gradesProvider);
  final periods = ref.watch(periodsProvider);
  final data = <SubjectData>[];
  for (var element in subjects) {
    final id = element.id!;
    final present = periods.withSubjectId(id).present;
    final absent = periods.reduceList((data) => data.subjectId == id).absent;
    final cancel = periods.reduceList((data) => data.subjectId == id).cancel;
    final subGrades = grades.reduceList((item) => item.subjectId == id);
    final totalGrad = subGrades.map((e) => e.gradeValue * e.credits).addition;
    final credits = subGrades.map((e) => e.credits).addition;
    final subData = SubjectData(
      subject: element,
      present: present,
      absent: absent,
      cancel: cancel,
      credits: credits,
      grade: credits == 0 ? 0 : totalGrad / credits,
      hasGrade: subGrades.isNotEmpty,
    );
    data.add(subData);
  }
  return data;
});
final gradeDataProvider = Provider<List<GradeData>>((ref) {
  final grades = ref.watch(gradesProvider);
  final subjects = ref.watch(subjectsProvider);
  final data = <GradeData>[];
  for (var item in grades) {
    final subject = subjects.findItem((e) => e.id == item.subjectId);
    if (subject != null) {
      data.add(GradeData(item, subject));
    }
  }
  data.sort((o, t) => o.grade.dateTime.compareTo(t.grade.dateTime));
  return data;
});
