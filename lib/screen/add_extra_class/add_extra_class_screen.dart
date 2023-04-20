import 'package:attend_book/provider/preference_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/custom_app_bar.dart';
import '../../components/my_dropdown.dart';
import '../../convert/extension.dart';
import '../../database/entity/period.dart';
import '../../helpers/enums.dart';
import '../../helpers/type_def_utils.dart';
import '../../provider/providers.dart';
import '../../tile/tile_callback.dart';
import '../add_grade/date_input.dart';
import '../add_timetable/class_time_input.dart';
import '../add_timetable/duration_seekbar.dart';
import 'extra_class_present_status.dart';

class AddExtraClassScreen extends StatelessWidget {
  static const route = 'Add Extra Class Screen';
  const AddExtraClassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int subjectId = -1;
    final now = ModalRoute.of(context)?.settings.arguments as DateTime? ??
        DateTime.now();
    late DateTime dateTime = now.copyWith(hour: 9, minute: 0, second: 0);
    int duration = 60;
    PresentStatus? presentStatus;
    bool changed = false;

    void save(Reader read, void Function() pop) async {
      if (subjectId == -1 || presentStatus == null) {
        MyTileCallback.showSnackbar(
            context: context,
            message: subjectId == -1
                ? 'You have not selected any subjects yet.'
                : 'You have not selected the present status yet.');
        return;
      }
      final term = read(currentTermPreferencesProvider);
      final subject =
          await read(subjectDaoProvider).findSubjectWithId(subjectId, term);
      if (subject == null) return;
      final periodDao = read(periodDaoProvider);
      final period = Period(
        pId: null,
        subjectId: subjectId,
        dateTimeString: dateTime.toIso8601String(),
        duration: duration,
        statusIndex: presentStatus!.index,
        timetableId: null,
        term: term,
      );
      await periodDao.insertPeriod(period);
      MyTileCallback.showSnackbar(
          context: context, message: 'Extra class added successfully.');
      pop();
    }

    return WillPopScope(
      onWillPop: () async {
        return changed
            ? await showAlertDialog(
                  context: context,
                  showTitle: false,
                  content: 'Do you want discard changes and quit editing ?',
                  positiveText: 'Discard',
                  negativeText: 'Keep editing',
                ) ??
                false
            : true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Add extra class',
          keyString: null,
          actions: [
            Consumer(
              builder: (context, ref, child) => IconButton(
                onPressed: () => save(ref.read, () => Navigator.pop(context)),
                icon: const Icon(Icons.save_rounded),
                tooltip: 'Save',
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DateInput(
                        isReminder: true,
                        dateTime: dateTime,
                        callback: (val) {
                          dateTime = dateTime.copyWith(
                            day: val.day,
                            month: val.month,
                            year: val.year,
                          );
                          if (!changed) changed = true;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ClassTimeInput(
                        time: dateTime,
                        callback: (val) {
                          dateTime = dateTime
                              .copyTimeOfDay(TimeOfDay.fromDateTime(val));
                          if (!changed) changed = true;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Consumer(
                  builder: (context, ref, child) {
                    return MyDropdown(
                      items: ref
                          .watch(subjectsProvider)
                          .map((e) => MyDropdownItem(e.name, e.id!))
                          .toList(),
                      value: null,
                      prefixText: 'Subject',
                      emptyText: 'You have no subjects',
                      unselectedText: 'Select subject',
                      isSubject: true,
                      intCallback: (val) {
                        subjectId = val;
                        if (!changed) changed = true;
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                ExtraClassPresentStatus(
                  presentStatus: presentStatus,
                  callback: (val) {
                    presentStatus = val;
                    if (!changed) changed = true;
                  },
                ),
                const SizedBox(height: 10),
                DurationSeekbar(
                  duration: duration,
                  isNew: true,
                  callback: (val) {
                    duration = val;
                    if (!changed) changed = true;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
