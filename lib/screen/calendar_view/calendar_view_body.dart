import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/custom_app_bar.dart';
import '../../convert/extension.dart';
import '../../provider/providers.dart';
import '../../widget/my_custom_calendar.dart';
import 'calendar_status_card.dart';

class CalendarViewBody extends StatefulWidget {
  final int subjectId;

  const CalendarViewBody({Key? key, required this.subjectId}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _CalendarViewBodyState createState() => _CalendarViewBodyState();
}

class _CalendarViewBodyState extends State<CalendarViewBody> {
  var dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall?.copyWith(fontSize: 13);
    final child1 = Stack(
      children: [
        Consumer(
          builder: (context, ref, child) => MyCustomCalendarDatePicker(
            initialDate: dateTime,
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            onDateChanged: (val) => setState(() => dateTime = val),
            markDateTimes: ref.watch(
              periodsProvider.select(
                (value) => value
                    .reduceList((data) => data.subjectId == widget.subjectId)
                    .reduceToField(
                      (item) => item.dateTime,
                      (one, two) => one.isAtSameDayAs(two),
                    ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 24,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Text('  repersents has record.', style: style),
            ],
          ),
        ),
      ],
    );
    final child2 = CalendarStatusCard(
      dateText: Center(
        child: Text(dateTime.format('EEE, MMM d, yyyy'), style: style),
      ),
      subjectId: widget.subjectId,
      dateTime: dateTime,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasSpace = constraints.biggest.height > 600;
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: CustomAppBar(
              keyString: null,
              titleBuilder: () => Consumer(
                builder: (context, ref, child) => Text(
                  ref.watch(
                    subjectsProvider.select(
                      (value) =>
                          '${value.findItem((i) => i.id == widget.subjectId)!.name}\'s calendar view',
                    ),
                  ),
                ),
              ),
              bottom: hasSpace || constraints.biggest.height < 300
                  ? null
                  : const TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(text: 'Calendar'),
                        Tab(text: 'Analysis'),
                      ],
                    ),
            ),
            body: hasSpace
                ? Column(children: [
                    Expanded(flex: 45, child: child1),
                    Expanded(flex: 55, child: child2),
                  ])
                : TabBarView(children: [child1, child2]),
          ),
        );
      },
    );
  }
}
