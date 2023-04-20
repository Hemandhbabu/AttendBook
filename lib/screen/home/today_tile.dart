import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../convert/extension.dart';
import '../../convert/today_convert.dart';
import '../../helpers/enums.dart';
import '../../helpers/type_def_utils.dart';
import '../../tile/tile.dart';
import '../../tile/tile_callback.dart';

class TodayTile extends ConsumerWidget {
  final TodayData todayData;

  const TodayTile({
    Key? key,
    required this.todayData,
  }) : super(key: key);

  static Tile<PresentStatus, TilePressActionsEnum> buildTile(
    BuildContext context,
    TodayData todayData,
    Reader read,
  ) {
    final timetable = todayData.timetable;
    final period = todayData.period;
    final subject = todayData.subject;
    if (timetable == null && period == null) return const Tile(title: 'Error');
    final date = timetable?.time ?? period!.dateTime;
    final duration = timetable?.duration ?? period!.duration;
    return Tile(
      leading: SizedBox(
        height: 42,
        width: 42,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: LeadingIcon(
            key: ValueKey(period?.statusIndex ?? 10),
            status: period?.status,
          ),
        ),
      ),
      title: subject.name,
      trailingTitle: date.timeFormat(
        MediaQuery.of(context).alwaysUse24HourFormat,
      ),
      trailingSubtitle: '$duration mins',
      trailingIndicatorColor: subject.color,
      subtitle: '${period?.isExtra == true ? 'Extra' : 'Regular'} class',
      // subtitle: NumberOfClassReq.fromPresentAbsent(
      //   present: subject.present,
      //   absent: subject.absent,
      //   reqPercent: subject.subject.requiredPercent ?? requiredPercent,
      // ).remarkSmall,
      moreAction: SheetTileActionData(
        selectedAction: period?.status,
        actions: presentStatusActions,
        valueChanged: (context, action) => presentCallback(
          context,
          action,
          todayData,
          read,
        ),
      ),
      pressAction: SheetTileActionData(
        actions: [calendarAction, if (period != null) deleteAction],
        valueChanged: (context, action) => MyTileCallback.periodPressCallback(
          context: context,
          press: action,
          subjectId: subject.id!,
          period: period,
          read: read,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => buildTile(
        context,
        todayData,
        ref.read,
      );

  static void presentCallback(
    BuildContext context,
    PresentStatus action,
    TodayData today,
    Reader read,
  ) =>
      today.period == null
          ? MyTileCallback.homeTodayCallback(
              context: context,
              subjectId: today.subject.id!,
              presentStatus: action,
              timetable: today.timetable!,
              read: read,
            )
          : MyTileCallback.periodChangeCallback(
              context: context,
              period: today.period!,
              status: action,
              read: read,
            );
}
