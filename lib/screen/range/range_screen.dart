import 'package:flutter/material.dart' hide showDateRangePicker;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/custom_app_bar.dart';
import '../../../convert/extension.dart';
import '../../components/my_list_view.dart';
import '../../provider/providers.dart';
import '../period/period_tile.dart';
import 'date_card.dart';

class RangeScreen extends StatefulWidget {
  static const route = 'range-view-screen';
  const RangeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RangeScreenState createState() => _RangeScreenState();
}

class _RangeScreenState extends State<RangeScreen> {
  late DateTimeRange _range;
  @override
  void initState() {
    final now = DateTime.now();
    _range = DateTimeRange(
      start: now.copyWith(day: 1, hour: 0, minute: 0, second: 0),
      end: now,
    );
    super.initState();
  }

  void dateChange(DateTimeRange range) => setState(() => _range = range);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        keyString: RangeScreen.route,
        title: 'Range view',
        bottom: DateCard(range: _range, onChanged: dateChange),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Pick date range',
        onPressed: () => DateCard.pickRange(context, _range, dateChange),
        child: const Icon(Icons.date_range_rounded),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final periods = ref.watch(
            periodsProvider.select(
              (value) => value.reduceList(
                (item) =>
                    item.dateTime.millisecondsSinceEpoch >
                        _range.start.millisecondsSinceEpoch &&
                    item.dateTime.millisecondsSinceEpoch <
                        _range.end.millisecondsSinceEpoch,
              ),
            ),
          );
          periods.sort((one, two) => one.dateTime.compareTo(two.dateTime));
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: MyListView(
              key: ValueKey(_range),
              keyString: RangeScreen.route,
              emptyText: 'You have no classes in this date range',
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: periods.length,
              itemBuilder: (index) => PeriodTile(period: periods[index]),
            ),
          );
        },
      ),
    );
  }
}
