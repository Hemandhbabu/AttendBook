import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../convert/extension.dart';
import '../../database/entity/grade.dart';
import '../../database/entity/period.dart';
import '../../database/entity/subject.dart';
import '../../database/entity/timetable.dart';
import '../../helpers/backup_and_restore.dart';
import '../../helpers/export_helper.dart';
import '../../helpers/type_def_utils.dart';
import '../../provider/preference_provider.dart';
import '../../provider/providers.dart';
import '../../tile/tile.dart';
import '../../tile/tile_callback.dart';

const _folder = 'attend_book_backup';
const _file = 'attend_book_backup_file.bk';

class BackupPreference extends ConsumerStatefulWidget {
  const BackupPreference({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BackupPreferenceState createState() => _BackupPreferenceState();
}

class _BackupPreferenceState extends ConsumerState<BackupPreference> {
  bool loading = false;

  String buildSubjects(List<Subject> subjects) {
    return json.encode(subjects.map((e) => e.toMap()).toList());
  }

  Future<String> buildTimetables() async {
    final timetables =
        await ref.read(timetableDaoProvider).findAllTimetablesBackup();
    return json.encode(timetables.map((e) => e.toMap()).toList());
  }

  Future<String> buildPeriods() async {
    final periods = await ref.read(periodDaoProvider).findAllPeriodsBackup();
    return json.encode(periods.map((e) => e.toMap()).toList());
  }

  Future<String> buildGrades() async {
    final grades = await ref.read(gradeDaoProvider).getAllGradesBackup();
    return json.encode(grades.map((e) => e.toMap()).toList());
  }

  Future<String> buildPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final map = <String, dynamic>{};
    map.addEntries(keys.map((e) => MapEntry(e, prefs.get(e))));
    return json.encode([map]);
  }

  Future<String> buildBackupData(List<Subject> data) async {
    final subjects = buildSubjects(data);
    final timetables = await buildTimetables();
    final periods = await buildPeriods();
    final grades = await buildGrades();
    final prefs = await buildPrefs();
    return json.encode([subjects, timetables, periods, grades, prefs]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !loading,
      child: Tile(
        margin: EdgeInsets.zero,
        borderRadius: BorderRadius.zero,
        title: 'Backup',
        tileHeight: null,
        trailing: loading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator.adaptive(strokeWidth: 3),
              )
            : null,
        onTap: loading
            ? null
            : () async {
                setState(() => loading = true);
                final subjects =
                    await ref.read(subjectDaoProvider).findAllSubjectsBackup();
                setState(() => loading = false);
                if (subjects.isNotEmpty) {
                  backupAction(
                    context: context,
                    backupData: await buildBackupData(subjects),
                    driveFolder: _folder,
                    driveFile: _file,
                    buildLocalFolder: ExportHelper.getBackupPath,
                    localFile: 'AttendBookBackup-'
                        '${DateTime.now().format('yyyyMMddHHmmss')}.bk',
                    androidVersion: await AndroidVersion.getVersion() ?? 19,
                    loadingChange: (value) => setState(() => loading = value),
                  );
                } else {
                  MyTileCallback.showSnackbar(
                    context: context,
                    message: 'You have no data to be backed up',
                  );
                }
              },
      ),
    );
  }
}

class RestorePreference extends ConsumerStatefulWidget {
  const RestorePreference({Key? key}) : super(key: key);

  static Future<void> restore({
    required BuildContext context,
    required void Function(bool) loadingChange,
    required void Function() onDone,
    required Reader read,
  }) async =>
      restoreAction(
        context: context,
        buildLocalFolder: ExportHelper.getBackupPath,
        driveFile: _file,
        androidVersion: await AndroidVersion.getVersion() ?? 19,
        restore: (value) => _restoreData(read, value),
        loadingChange: loadingChange,
        onDone: onDone,
      );

  static Future<bool?> _restoreData(
    Reader read,
    String restoredData,
  ) async {
    final value = (json.decode(restoredData) as List).cast<String>();
    final data = value
        .map((e) => (json.decode(e) as List).cast<Map<String, dynamic>>())
        .toList();
    await read(subjectDaoProvider).insertSubjects(_buildSubjects(data[0]));
    await read(timetableDaoProvider)
        .insertTimetables(_buildTimetables(data[1]));
    await read(periodDaoProvider).insertPeriods(_buildPeriods(data[2]));
    await read(gradeDaoProvider).insertGrades(_buildGrades(data[3]));
    await _restorePrefs(data[4][0], read);
    return true;
  }

  static List<Subject> _buildSubjects(List<Map<String, dynamic>> value) =>
      value.map((e) => Subject.fromMap(e)).toList();

  static List<Timetable> _buildTimetables(List<Map<String, dynamic>> value) =>
      value.map((e) => Timetable.fromMap(e)).toList();

  static List<Period> _buildPeriods(List<Map<String, dynamic>> value) =>
      value.map((e) => Period.fromMap(e)).toList();

  static List<Grade> _buildGrades(List<Map<String, dynamic>> value) =>
      value.map((e) => Grade.fromMap(e)).toList();

  static Future<void> _restorePrefs(
    Map<String, dynamic> value,
    Reader read,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    for (var item in value.entries) {
      final key = item.key;
      final value = item.value;
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
    }
    await prefs.remove('lock-screen-fingerprint');
    await read(currentTermPreferencesProvider.notifier)
        .setInt(value['current-term'] ?? 1);
  }

  @override
  // ignore: library_private_types_in_public_api
  _RestorePreferenceState createState() => _RestorePreferenceState();
}

class _RestorePreferenceState extends ConsumerState<RestorePreference> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Tile(
      margin: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      title: 'Restore',
      tileHeight: null,
      trailing: loading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator.adaptive(strokeWidth: 3),
            )
          : null,
      onTap: loading
          ? null
          : () async {
              setState(() => loading = true);
              final subjectsEmpty =
                  (await ref.read(subjectDaoProvider).findAllSubjectsBackup())
                      .isEmpty;
              setState(() => loading = false);
              if (subjectsEmpty) {
                if (!mounted) return;
                RestorePreference.restore(
                  context: context,
                  loadingChange: (value) =>
                      loading != value ? setState(() => loading = value) : null,
                  onDone: () {},
                  read: ref.read,
                );
              } else {
                MyTileCallback.showSnackbar(
                  context: context,
                  message: 'Restore can be only done when there is no subjects',
                );
              }
            },
    );
  }
}
