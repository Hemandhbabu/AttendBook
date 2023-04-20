import 'package:attend_book/screen/timetable/timetable_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/my_list_view.dart';
import '../../convert/extension.dart';
import '../../database/entity/timetable.dart';
import '../../helpers/constants.dart';
import '../../helpers/enums.dart';
import '../../provider/providers.dart';
import '../../tile/tile.dart';
import '../../tile/tile_callback.dart';

class WeekdayTimetableCard extends ConsumerWidget {
  const WeekdayTimetableCard({Key? key, required this.weekDay})
      : super(key: key);

  final int weekDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetables = ref.watch(
      timetablesProvider.select(
        (value) => value.reduceList((item) => item.weekday == weekDay),
      ),
    );
    return MyListView(
      keyString: TimetableScreen.route,
      emptyText: 'You have no timetable set on\n${weekDays[weekDay]}',
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: timetables.length,
      itemBuilder: (index) => TimetableTile(timetable: timetables[index]),
    );
  }
}

class TimetableTile extends ConsumerWidget {
  const TimetableTile({Key? key, required this.timetable}) : super(key: key);

  final Timetable timetable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subject = ref.watch(
      subjectsProvider.select(
        (value) => value.findItem((i) => i.id == timetable.subjectId),
      ),
    );
    if (subject == null) return const Tile(title: 'An error occured');
    return Tile(
      leading: LeadingText(
        big: '${timetable.duration}',
        small: 'mins',
        color: subject.color,
        isNotify: timetable.notify,
      ),
      title: subject.name,
      subtitle: timetable.note,
      showTileOnActions: true,
      trailingTitle: timetable.time.timeFormat(
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
