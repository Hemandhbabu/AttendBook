import 'package:floor/floor.dart';

import '../entity/period.dart';

@dao
abstract class PeriodDao {
  @Query('SELECT * FROM Period WHERE term = :term AND timetableId = :timetable')
  Future<List<Period>> findPeriodsWithTimetableId(int timetable, int term);

  @Query('SELECT * FROM Period WHERE term = :term ORDER BY dateTimeString DESC')
  Future<List<Period>> findAllPeriods(int term);

  @Query('SELECT * FROM Period')
  Future<List<Period>> findAllPeriodsBackup();

  @Query('SELECT * FROM Period WHERE term = :term ORDER BY dateTimeString DESC')
  Stream<List<Period>> findAllPeriodsAsStream(int term);

  @insert
  Future<int> insertPeriod(Period period);

  @insert
  Future<void> insertPeriods(List<Period> periods);

  @update
  Future<void> updatePeriod(Period period);

  @delete
  Future<void> deletePeriod(Period period);

  @delete
  Future<void> deletePeriods(List<Period> periods);
}
