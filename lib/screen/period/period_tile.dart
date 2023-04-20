import 'package:flutter/material.dart' hide Dismissible;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../convert/extension.dart';
import '../../database/entity/period.dart';
import '../../helpers/enums.dart';
import '../../helpers/type_def_utils.dart';
import '../../provider/providers.dart';
import '../../tile/tile.dart';
import '../../tile/tile_callback.dart';

class PeriodTile extends ConsumerWidget {
  const PeriodTile({
    Key? key,
    required this.period,
    this.showDate = true,
  }) : super(key: key);

  final bool showDate;
  final Period period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subject = ref.watch(
      subjectsProvider.select(
        (value) => value.findItem((i) => i.id == period.subjectId),
      ),
    );
    if (subject == null) return const Tile(title: 'An error occured');
    return Tile(
      leading: LeadingIcon(status: period.status),
      title: subject.name,
      trailingTitle: period.dateTime.timeFormat(
        MediaQuery.of(context).alwaysUse24HourFormat,
      ),
      subtitle: showDate
          ? period.dateTime.format('MMM d, yyyy')
          : '${period.isExtra ? 'Extra' : 'Regular'} class',
      trailingSubtitle: '${period.duration} mins',
      trailingIndicatorColor: subject.color,
      pressAction: SheetTileActionData<TilePressActionsEnum>(
        actions: const [calendarAction, deleteAction],
        valueChanged: (context, action) => MyTileCallback.periodPressCallback(
          context: context,
          press: action,
          subjectId: subject.id!,
          period: period,
          read: ref.read,
        ),
      ),
      moreAction: SheetTileActionData<PresentStatus>(
        selectedAction: period.status,
        actions: presentStatusActions,
        valueChanged: (context, action) => presentCallback(
          context,
          action,
          ref.read,
        ),
      ),
    );
  }

  void presentCallback(
    BuildContext context,
    PresentStatus action,
    Reader read,
  ) =>
      MyTileCallback.periodChangeCallback(
        context: context,
        period: period,
        status: action,
        read: read,
      );
}
