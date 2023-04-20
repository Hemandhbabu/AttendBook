// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SubjectDao? _subjectDaoInstance;

  PeriodDao? _periodDaoInstance;

  TimetableDao? _timetableDaoInstance;

  GradeDao? _gradeDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Subject` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `colorValue` INTEGER NOT NULL, `note` TEXT, `term` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Period` (`pId` INTEGER PRIMARY KEY AUTOINCREMENT, `subjectId` INTEGER NOT NULL, `timetableId` INTEGER, `dateTimeString` TEXT NOT NULL, `duration` INTEGER NOT NULL, `statusIndex` INTEGER NOT NULL, `term` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Timetable` (`tId` INTEGER PRIMARY KEY AUTOINCREMENT, `subjectId` INTEGER NOT NULL, `weekday` INTEGER NOT NULL, `timeString` TEXT NOT NULL, `duration` INTEGER NOT NULL, `notifyBefore` INTEGER NOT NULL, `note` TEXT, `term` INTEGER NOT NULL, `notify` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Grade` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `gradeValue` REAL NOT NULL, `subjectId` INTEGER NOT NULL, `credits` INTEGER NOT NULL, `dateTimeString` TEXT NOT NULL, `note` TEXT, `term` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SubjectDao get subjectDao {
    return _subjectDaoInstance ??= _$SubjectDao(database, changeListener);
  }

  @override
  PeriodDao get periodDao {
    return _periodDaoInstance ??= _$PeriodDao(database, changeListener);
  }

  @override
  TimetableDao get timetableDao {
    return _timetableDaoInstance ??= _$TimetableDao(database, changeListener);
  }

  @override
  GradeDao get gradeDao {
    return _gradeDaoInstance ??= _$GradeDao(database, changeListener);
  }
}

class _$SubjectDao extends SubjectDao {
  _$SubjectDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _subjectInsertionAdapter = InsertionAdapter(
            database,
            'Subject',
            (Subject item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'colorValue': item.colorValue,
                  'note': item.note,
                  'term': item.term
                },
            changeListener),
        _subjectUpdateAdapter = UpdateAdapter(
            database,
            'Subject',
            ['id'],
            (Subject item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'colorValue': item.colorValue,
                  'note': item.note,
                  'term': item.term
                },
            changeListener),
        _subjectDeletionAdapter = DeletionAdapter(
            database,
            'Subject',
            ['id'],
            (Subject item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'colorValue': item.colorValue,
                  'note': item.note,
                  'term': item.term
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Subject> _subjectInsertionAdapter;

  final UpdateAdapter<Subject> _subjectUpdateAdapter;

  final DeletionAdapter<Subject> _subjectDeletionAdapter;

  @override
  Future<Subject?> findSubjectWithId(
    int id,
    int term,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM Subject WHERE term = ?2 AND id = ?1',
        mapper: (Map<String, Object?> row) => Subject(
            id: row['id'] as int?,
            name: row['name'] as String,
            colorValue: row['colorValue'] as int,
            note: row['note'] as String?,
            term: row['term'] as int),
        arguments: [id, term]);
  }

  @override
  Future<List<Subject>> findAllSubjects(int term) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Subject WHERE term = ?1 ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => Subject(
            id: row['id'] as int?,
            name: row['name'] as String,
            colorValue: row['colorValue'] as int,
            note: row['note'] as String?,
            term: row['term'] as int),
        arguments: [term]);
  }

  @override
  Future<List<Subject>> findAllSubjectsBackup() async {
    return _queryAdapter.queryList('SELECT * FROM Subject',
        mapper: (Map<String, Object?> row) => Subject(
            id: row['id'] as int?,
            name: row['name'] as String,
            colorValue: row['colorValue'] as int,
            note: row['note'] as String?,
            term: row['term'] as int));
  }

  @override
  Stream<List<Subject>> findAllSubjectsAsStream(int term) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Subject WHERE term = ?1 ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => Subject(
            id: row['id'] as int?,
            name: row['name'] as String,
            colorValue: row['colorValue'] as int,
            note: row['note'] as String?,
            term: row['term'] as int),
        arguments: [term],
        queryableName: 'Subject',
        isView: false);
  }

  @override
  Future<int> insertSubject(Subject subject) {
    return _subjectInsertionAdapter.insertAndReturnId(
        subject, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertSubjects(List<Subject> subjects) async {
    await _subjectInsertionAdapter.insertList(
        subjects, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSubject(Subject subject) async {
    await _subjectUpdateAdapter.update(subject, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSubject(Subject subject) async {
    await _subjectDeletionAdapter.delete(subject);
  }
}

class _$PeriodDao extends PeriodDao {
  _$PeriodDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _periodInsertionAdapter = InsertionAdapter(
            database,
            'Period',
            (Period item) => <String, Object?>{
                  'pId': item.pId,
                  'subjectId': item.subjectId,
                  'timetableId': item.timetableId,
                  'dateTimeString': item.dateTimeString,
                  'duration': item.duration,
                  'statusIndex': item.statusIndex,
                  'term': item.term
                },
            changeListener),
        _periodUpdateAdapter = UpdateAdapter(
            database,
            'Period',
            ['pId'],
            (Period item) => <String, Object?>{
                  'pId': item.pId,
                  'subjectId': item.subjectId,
                  'timetableId': item.timetableId,
                  'dateTimeString': item.dateTimeString,
                  'duration': item.duration,
                  'statusIndex': item.statusIndex,
                  'term': item.term
                },
            changeListener),
        _periodDeletionAdapter = DeletionAdapter(
            database,
            'Period',
            ['pId'],
            (Period item) => <String, Object?>{
                  'pId': item.pId,
                  'subjectId': item.subjectId,
                  'timetableId': item.timetableId,
                  'dateTimeString': item.dateTimeString,
                  'duration': item.duration,
                  'statusIndex': item.statusIndex,
                  'term': item.term
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Period> _periodInsertionAdapter;

  final UpdateAdapter<Period> _periodUpdateAdapter;

  final DeletionAdapter<Period> _periodDeletionAdapter;

  @override
  Future<List<Period>> findPeriodsWithTimetableId(
    int timetable,
    int term,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Period WHERE term = ?2 AND timetableId = ?1',
        mapper: (Map<String, Object?> row) => Period(
            pId: row['pId'] as int?,
            subjectId: row['subjectId'] as int,
            dateTimeString: row['dateTimeString'] as String,
            duration: row['duration'] as int,
            statusIndex: row['statusIndex'] as int,
            timetableId: row['timetableId'] as int?,
            term: row['term'] as int),
        arguments: [timetable, term]);
  }

  @override
  Future<List<Period>> findAllPeriods(int term) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Period WHERE term = ?1 ORDER BY dateTimeString DESC',
        mapper: (Map<String, Object?> row) => Period(
            pId: row['pId'] as int?,
            subjectId: row['subjectId'] as int,
            dateTimeString: row['dateTimeString'] as String,
            duration: row['duration'] as int,
            statusIndex: row['statusIndex'] as int,
            timetableId: row['timetableId'] as int?,
            term: row['term'] as int),
        arguments: [term]);
  }

  @override
  Future<List<Period>> findAllPeriodsBackup() async {
    return _queryAdapter.queryList('SELECT * FROM Period',
        mapper: (Map<String, Object?> row) => Period(
            pId: row['pId'] as int?,
            subjectId: row['subjectId'] as int,
            dateTimeString: row['dateTimeString'] as String,
            duration: row['duration'] as int,
            statusIndex: row['statusIndex'] as int,
            timetableId: row['timetableId'] as int?,
            term: row['term'] as int));
  }

  @override
  Stream<List<Period>> findAllPeriodsAsStream(int term) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Period WHERE term = ?1 ORDER BY dateTimeString DESC',
        mapper: (Map<String, Object?> row) => Period(
            pId: row['pId'] as int?,
            subjectId: row['subjectId'] as int,
            dateTimeString: row['dateTimeString'] as String,
            duration: row['duration'] as int,
            statusIndex: row['statusIndex'] as int,
            timetableId: row['timetableId'] as int?,
            term: row['term'] as int),
        arguments: [term],
        queryableName: 'Period',
        isView: false);
  }

  @override
  Future<int> insertPeriod(Period period) {
    return _periodInsertionAdapter.insertAndReturnId(
        period, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertPeriods(List<Period> periods) async {
    await _periodInsertionAdapter.insertList(periods, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePeriod(Period period) async {
    await _periodUpdateAdapter.update(period, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePeriod(Period period) async {
    await _periodDeletionAdapter.delete(period);
  }

  @override
  Future<void> deletePeriods(List<Period> periods) async {
    await _periodDeletionAdapter.deleteList(periods);
  }
}

class _$TimetableDao extends TimetableDao {
  _$TimetableDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _timetableInsertionAdapter = InsertionAdapter(
            database,
            'Timetable',
            (Timetable item) => <String, Object?>{
                  'tId': item.tId,
                  'subjectId': item.subjectId,
                  'weekday': item.weekday,
                  'timeString': item.timeString,
                  'duration': item.duration,
                  'notifyBefore': item.notifyBefore,
                  'note': item.note,
                  'term': item.term,
                  'notify': item.notify ? 1 : 0
                },
            changeListener),
        _timetableUpdateAdapter = UpdateAdapter(
            database,
            'Timetable',
            ['tId'],
            (Timetable item) => <String, Object?>{
                  'tId': item.tId,
                  'subjectId': item.subjectId,
                  'weekday': item.weekday,
                  'timeString': item.timeString,
                  'duration': item.duration,
                  'notifyBefore': item.notifyBefore,
                  'note': item.note,
                  'term': item.term,
                  'notify': item.notify ? 1 : 0
                },
            changeListener),
        _timetableDeletionAdapter = DeletionAdapter(
            database,
            'Timetable',
            ['tId'],
            (Timetable item) => <String, Object?>{
                  'tId': item.tId,
                  'subjectId': item.subjectId,
                  'weekday': item.weekday,
                  'timeString': item.timeString,
                  'duration': item.duration,
                  'notifyBefore': item.notifyBefore,
                  'note': item.note,
                  'term': item.term,
                  'notify': item.notify ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Timetable> _timetableInsertionAdapter;

  final UpdateAdapter<Timetable> _timetableUpdateAdapter;

  final DeletionAdapter<Timetable> _timetableDeletionAdapter;

  @override
  Future<Timetable?> findTimetableWithId(
    int id,
    int term,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM Timetable WHERE term = ?2 AND tId = ?1',
        mapper: (Map<String, Object?> row) => Timetable(
            tId: row['tId'] as int?,
            weekday: row['weekday'] as int,
            subjectId: row['subjectId'] as int,
            timeString: row['timeString'] as String,
            duration: row['duration'] as int,
            notifyBefore: row['notifyBefore'] as int,
            note: row['note'] as String?,
            term: row['term'] as int,
            notify: (row['notify'] as int) != 0),
        arguments: [id, term]);
  }

  @override
  Future<List<Timetable>> findAllTimetables(int term) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Timetable WHERE term = ?1 ORDER BY timeString ASC',
        mapper: (Map<String, Object?> row) => Timetable(
            tId: row['tId'] as int?,
            weekday: row['weekday'] as int,
            subjectId: row['subjectId'] as int,
            timeString: row['timeString'] as String,
            duration: row['duration'] as int,
            notifyBefore: row['notifyBefore'] as int,
            note: row['note'] as String?,
            term: row['term'] as int,
            notify: (row['notify'] as int) != 0),
        arguments: [term]);
  }

  @override
  Future<List<Timetable>> findAllTimetablesBackup() async {
    return _queryAdapter.queryList('SELECT * FROM Timetable',
        mapper: (Map<String, Object?> row) => Timetable(
            tId: row['tId'] as int?,
            weekday: row['weekday'] as int,
            subjectId: row['subjectId'] as int,
            timeString: row['timeString'] as String,
            duration: row['duration'] as int,
            notifyBefore: row['notifyBefore'] as int,
            note: row['note'] as String?,
            term: row['term'] as int,
            notify: (row['notify'] as int) != 0));
  }

  @override
  Stream<List<Timetable>> findAllTimeTablesAsStream(int term) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Timetable WHERE term = ?1 ORDER BY timeString ASC',
        mapper: (Map<String, Object?> row) => Timetable(
            tId: row['tId'] as int?,
            weekday: row['weekday'] as int,
            subjectId: row['subjectId'] as int,
            timeString: row['timeString'] as String,
            duration: row['duration'] as int,
            notifyBefore: row['notifyBefore'] as int,
            note: row['note'] as String?,
            term: row['term'] as int,
            notify: (row['notify'] as int) != 0),
        arguments: [term],
        queryableName: 'Timetable',
        isView: false);
  }

  @override
  Future<int> insertTimetable(Timetable timetable) {
    return _timetableInsertionAdapter.insertAndReturnId(
        timetable, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertTimetables(List<Timetable> timetables) async {
    await _timetableInsertionAdapter.insertList(
        timetables, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTimetable(Timetable timetable) async {
    await _timetableUpdateAdapter.update(timetable, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTimetable(Timetable timetable) async {
    await _timetableDeletionAdapter.delete(timetable);
  }

  @override
  Future<void> deleteTimetables(List<Timetable> timetables) async {
    await _timetableDeletionAdapter.deleteList(timetables);
  }
}

class _$GradeDao extends GradeDao {
  _$GradeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _gradeInsertionAdapter = InsertionAdapter(
            database,
            'Grade',
            (Grade item) => <String, Object?>{
                  'id': item.id,
                  'gradeValue': item.gradeValue,
                  'subjectId': item.subjectId,
                  'credits': item.credits,
                  'dateTimeString': item.dateTimeString,
                  'note': item.note,
                  'term': item.term
                },
            changeListener),
        _gradeUpdateAdapter = UpdateAdapter(
            database,
            'Grade',
            ['id'],
            (Grade item) => <String, Object?>{
                  'id': item.id,
                  'gradeValue': item.gradeValue,
                  'subjectId': item.subjectId,
                  'credits': item.credits,
                  'dateTimeString': item.dateTimeString,
                  'note': item.note,
                  'term': item.term
                },
            changeListener),
        _gradeDeletionAdapter = DeletionAdapter(
            database,
            'Grade',
            ['id'],
            (Grade item) => <String, Object?>{
                  'id': item.id,
                  'gradeValue': item.gradeValue,
                  'subjectId': item.subjectId,
                  'credits': item.credits,
                  'dateTimeString': item.dateTimeString,
                  'note': item.note,
                  'term': item.term
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Grade> _gradeInsertionAdapter;

  final UpdateAdapter<Grade> _gradeUpdateAdapter;

  final DeletionAdapter<Grade> _gradeDeletionAdapter;

  @override
  Future<List<Grade>> findAllGrades(int term) async {
    return _queryAdapter.queryList('SELECT * FROM Grade WHERE term = ?1',
        mapper: (Map<String, Object?> row) => Grade(
            id: row['id'] as int?,
            gradeValue: row['gradeValue'] as double,
            subjectId: row['subjectId'] as int,
            credits: row['credits'] as int,
            dateTimeString: row['dateTimeString'] as String,
            note: row['note'] as String?,
            term: row['term'] as int),
        arguments: [term]);
  }

  @override
  Stream<List<Grade>> findAllGradesAsStream(int term) {
    return _queryAdapter.queryListStream('SELECT * FROM Grade WHERE term = ?1',
        mapper: (Map<String, Object?> row) => Grade(
            id: row['id'] as int?,
            gradeValue: row['gradeValue'] as double,
            subjectId: row['subjectId'] as int,
            credits: row['credits'] as int,
            dateTimeString: row['dateTimeString'] as String,
            note: row['note'] as String?,
            term: row['term'] as int),
        arguments: [term],
        queryableName: 'Grade',
        isView: false);
  }

  @override
  Future<List<Grade>> getAllGradesBackup() async {
    return _queryAdapter.queryList('SELECT * FROM Grade',
        mapper: (Map<String, Object?> row) => Grade(
            id: row['id'] as int?,
            gradeValue: row['gradeValue'] as double,
            subjectId: row['subjectId'] as int,
            credits: row['credits'] as int,
            dateTimeString: row['dateTimeString'] as String,
            note: row['note'] as String?,
            term: row['term'] as int));
  }

  @override
  Future<int> insertGrade(Grade grade) {
    return _gradeInsertionAdapter.insertAndReturnId(
        grade, OnConflictStrategy.ignore);
  }

  @override
  Future<void> insertGrades(List<Grade> grades) async {
    await _gradeInsertionAdapter.insertList(grades, OnConflictStrategy.ignore);
  }

  @override
  Future<void> updateGrade(Grade grade) async {
    await _gradeUpdateAdapter.update(grade, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteGrade(Grade grade) async {
    await _gradeDeletionAdapter.delete(grade);
  }

  @override
  Future<void> deleteGrades(List<Grade> grades) async {
    await _gradeDeletionAdapter.deleteList(grades);
  }
}
