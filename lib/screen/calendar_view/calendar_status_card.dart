import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/center_text.dart';
import '../../convert/convert_classes.dart';
import '../../convert/extension.dart';
import '../../database/entity/period.dart';
import '../../provider/providers.dart';
import '../../tile/tile.dart' show TileAction, presentStatusActions;

const _padding = EdgeInsets.all(12);

class CalendarStatusCard extends ConsumerWidget {
  final Widget dateText;
  final int subjectId;
  final DateTime dateTime;
  static const borderRadius = BorderRadius.only(
    topLeft: Radius.circular(12),
    topRight: Radius.circular(12),
  );

  const CalendarStatusCard({
    Key? key,
    required this.subjectId,
    required this.dateTime,
    required this.dateText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectData = ref.watch(
      subjectDataProvider.select(
        (value) => value.findItem((i) => i.subject.id == subjectId)!,
      ),
    );
    final noOfClassReq = PercentConvert([subjectData]);
    final periods = ref.watch(
      periodsProvider.select(
        (value) => value.reduceList(
          (i) => i.subjectId == subjectId && i.dateTime.isAtSameDayAs(dateTime),
        ),
      ),
    );
    final dailyAnalysis = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CenterText('Daily analysis', padding: _padding),
        const SizedBox(height: 6),
        ListTileWithColor(
          action: presentStatusActions[0],
          title: 'Present',
          trailing: periods.present.toString(),
        ),
        const Divider(height: 3, indent: 20, endIndent: 20),
        ListTileWithColor(
          action: presentStatusActions[1],
          title: 'Absent',
          trailing: periods.absent.toString(),
        ),
        const Divider(height: 3, indent: 20, endIndent: 20),
        ListTileWithColor(
          action: presentStatusActions[2],
          title: 'Cancel',
          trailing: periods.cancel.toString(),
        ),
        const SizedBox(height: 16),
        dateText,
        const SizedBox(height: 16),
      ],
    );
    final subjectAnalysis = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CenterText('Subject analysis', padding: _padding),
        const SizedBox(height: 6),
        ListTileWithColor(
          title: 'Obtained percentage',
          trailing:
              '${getFormattedValueString(noOfClassReq.classValue * 100)} %',
        ),
        const Divider(height: 3, indent: 20, endIndent: 20),
        ListTileWithColor(
          title: 'Present classes',
          trailing: '${subjectData.present}',
        ),
        const Divider(height: 3, indent: 20, endIndent: 20),
        ListTileWithColor(
          title: 'Absent classes',
          trailing: '${subjectData.absent}',
        ),
        const Divider(height: 3, indent: 20, endIndent: 20),
        ListTileWithColor(
          title: 'Cancelled classes',
          trailing: '${subjectData.cancel}',
        ),
        const SizedBox(height: 16),
      ],
    );
    return Card(
      margin: const EdgeInsets.only(top: 4),
      shape: const RoundedRectangleBorder(borderRadius: borderRadius),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          shrinkWrap: true,
          children: [
            const SizedBox(height: 16),
            dailyAnalysis,
            const Divider(height: 24),
            subjectAnalysis,
          ],
        ),
      ),
    );
  }
}

class ListTileWithColor extends StatelessWidget {
  final TileAction? action;
  final String title;
  final String trailing;
  const ListTileWithColor({
    Key? key,
    this.action,
    required this.title,
    required this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: action?.icon == null
          ? null
          : Icon(action!.icon, color: action?.color),
      title: Text(title, style: TextStyle(color: action?.color)),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Text(trailing, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
