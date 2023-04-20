import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/custom_app_bar.dart';
import '../../components/my_list_view.dart';
import '../../convert/extension.dart';
import '../../database/entity/subject.dart';
import '../../database/entity/timetable.dart';
import '../../helpers/constants.dart';
import '../../helpers/enums.dart';
import '../../provider/providers.dart';
import '../../tile/tile.dart';
import '../../tile/tile_callback.dart';
import '../add_timetable/add_time_table_screen.dart';

class SubjectTimetableScreen extends ConsumerWidget {
  static const route = 'Subject-Timetable-Screen';
  const SubjectTimetableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ModalRoute.of(context)?.settings.arguments as int?;
    final subject = ref.watch(
      subjectsProvider.select(
        (value) => value.findItem((item) => item.id == id)!,
      ),
    );
    return Scaffold(
      appBar: CustomAppBar(
        title: '${subject.name}\'s timetables',
        keyString: route,
      ),
      body: _Body(subject: subject),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Set timetable',
        onPressed: () => Navigator.pushNamed(
          context,
          AddTimetableScreen.route,
          arguments: AddTimetableArg(subjectId: id),
        ),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  final Subject subject;
  const _Body({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetables = ref.watch(
      timetablesProvider.select(
        (value) => value.reduceList((item) => item.subjectId == subject.id),
      ),
    );
    timetables.sort((one, two) => one.weekday.compareTo(two.weekday));
    return MyListView(
      keyString: SubjectTimetableScreen.route,
      padding: const EdgeInsets.only(bottom: 80),
      emptyText: 'You have no timetable set in ${subject.name}',
      itemCount: timetables.length,
      itemBuilder: (index) => SubjectTimetableTile(
        timetable: timetables[index],
        subject: subject,
      ),
    );
  }
}

class SubjectTimetableTile extends ConsumerWidget {
  const SubjectTimetableTile({
    Key? key,
    required this.timetable,
    required this.subject,
  }) : super(key: key);

  final Timetable timetable;
  final Subject subject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tile(
      leading: LeadingText(
        big: '${timetable.duration}',
        small: 'mins',
        color: subject.color,
        isNotify: timetable.notify,
      ),
      title: subject.name,
      subtitle: timetable.note ?? '',
      showTileOnActions: true,
      trailingTitle: weekDays[timetable.weekday],
      trailingSubtitle: timetable.time.timeFormat(
        MediaQuery.of(context).alwaysUse24HourFormat,
      ),
      pressAction: SheetTileActionData<TilePressActionsEnum>(
        actions: [
          timetable.notify ? unNotifyAction : notifyAction,
          editAction,
          deleteAction,
        ],
        valueChanged: (context, val) => MyTileCallback.timetableCallback(
          context: context,
          val: val,
          name: subject.name,
          timetable: timetable,
          read: ref.read,
        ),
      ),
    );
  }
}
