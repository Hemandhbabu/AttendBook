import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/custom_app_bar.dart';
import '../../components/my_dropdown.dart';
import '../../convert/extension.dart';
import '../../database/entity/timetable.dart';
import '../../helpers/type_def_utils.dart';
import '../../provider/add_timetable_provider.dart';
import '../../provider/preference_provider.dart';
import '../../provider/providers.dart';
import '../../tile/tile_callback.dart';
import '../add_subject/name_input.dart';
import 'class_time_input.dart';
import 'duration_seekbar.dart';
import 'notify_class_tile.dart';
import 'week_day_tile.dart';

class AddTimetableScreen extends StatelessWidget {
  static const route = 'Add time table screen';
  const AddTimetableScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments as AddTimetableArg?;
    bool changed = false;
    final provider = AddTimetableProvider(
      loadedTimetable: arg?.timetable,
      subjectId: arg?.subjectId,
    );
    return WillPopScope(
      onWillPop: () async {
        return changed
            ? await showAlertDialog(
                  context: context,
                  content: 'Do you want discard changes and quit editing ?',
                  positiveText: 'Discard',
                  negativeText: 'Keep editing',
                ) ??
                false
            : true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          keyString: null,
          title: arg?.timetable == null ? 'Set timetable' : 'Edit timetable',
          actions: [
            Consumer(
              builder: (context, ref, _) => IconButton(
                onPressed: () => save(context, provider, ref.read),
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
              children: [
                ClassTimeInput(
                  time: provider.time,
                  callback: (val) {
                    provider.time = val;
                    if (!changed) changed = true;
                  },
                ),
                const SizedBox(height: 10),
                Consumer(
                  builder: (context, ref, child) {
                    final subject = provider.subjectId <= 0
                        ? null
                        : ref
                            .read(subjectsProvider)
                            .findItem((data) => data.id == provider.subjectId);
                    return MyDropdown(
                      items: subject == null
                          ? ref
                              .watch(subjectsProvider)
                              .map((e) => MyDropdownItem(e.name, e.id!))
                              .toList()
                          : [MyDropdownItem(subject.name, subject.id!)],
                      value: subject?.id,
                      prefixText: 'Subject',
                      emptyText: 'You have no subjects',
                      unselectedText: 'Select subject',
                      isSubject: true,
                      intCallback: (val) {
                        provider.subjectId = val;
                        if (!changed) changed = true;
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                WeekDayTile(
                  provider: provider,
                  onChanged: () => changed ? null : changed = true,
                ),
                const SizedBox(height: 10),
                DurationSeekbar(
                  isNew: provider.isNew,
                  duration: provider.duration,
                  callback: (val) {
                    provider.duration = val;
                    if (!changed) changed = true;
                  },
                ),
                const SizedBox(height: 10),
                NotifyClassTile(
                  provider: provider,
                  onChanged: () => changed ? null : changed = true,
                ),
                const SizedBox(height: 10),
                NameInput(
                  minLines: 3,
                  maxLines: 5,
                  nextFocusNode: null,
                  initialValue: provider.note,
                  onChange: (value) {
                    provider.note = value;
                    if (!changed) changed = true;
                  },
                  onSave: (_) {},
                  labelText: 'Note',
                  capitalization: TextCapitalization.sentences,
                  validate: (_) => null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void save(
    BuildContext context,
    AddTimetableProvider provider,
    Reader read,
  ) async {
    if (provider.subjectId == -1) {
      MyTileCallback.showSnackbar(
          context: context, message: 'You have not selected any subjects yet.');
      return;
    }
    if (provider.weekday == null || provider.weekday! < 0) {
      MyTileCallback.showSnackbar(
          context: context,
          message: 'You have not selected any day of week yet.');
      return;
    }
    final validat = provider.validate(read(timetablesProvider));
    if (validat != null) {
      await showAlertDialog(
        context: context,
        showTitle: false,
        content: '$validat\nDo you want to continue ?',
        action: (context) => _saveAction(context, provider, read),
      );
      return;
    }
    _saveAction(context, provider, read);
  }
}

void _saveAction(
  BuildContext context,
  AddTimetableProvider provider,
  Reader read,
) {
  final val =
      read(subjectsProvider).findItem((data) => data.id == provider.subjectId);
  if (val != null) {
    provider.save(
      context: context,
      name: val.name,
      currentTerm: read(currentTermPreferencesProvider),
      dao: read(timetableDaoProvider),
      read: read,
      pop: () => Navigator.pop(context),
      alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
    );
  }
}

class AddTimetableArg {
  final int? subjectId;
  final Timetable? timetable;

  AddTimetableArg({this.timetable, this.subjectId});
}
