import 'package:floor/floor.dart';

import '../entity/timetable.dart';

@dao
abstract class TimetableDao {
  @Query('SELECT * FROM Timetable WHERE term = :term AND tId = :id')
  Future<Timetable?> findTimetableWithId(int id, int term);

  @Query('SELECT * FROM Timetable WHERE term = :term ORDER BY timeString ASC')
  Future<List<Timetable>> findAllTimetables(int term);

  @Query('SELECT * FROM Timetable')
  Future<List<Timetable>> findAllTimetablesBackup();

  @Query('SELECT * FROM Timetable WHERE term = :term ORDER BY timeString ASC')
  Stream<List<Timetable>> findAllTimeTablesAsStream(int term);

  @insert
  Future<int> insertTimetable(Timetable timetable);

  @insert
  Future<void> insertTimetables(List<Timetable> timetables);

  @update
  Future<void> updateTimetable(Timetable timetable);

  @delete
  Future<void> deleteTimetable(Timetable timetable);

  @delete
  Future<void> deleteTimetables(List<Timetable> timetables);
}
