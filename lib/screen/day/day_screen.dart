import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/custom_app_bar.dart';
import '../../../convert/extension.dart';
import '../../components/my_list_view.dart';
import '../../provider/providers.dart';
import '../add_extra_class/add_extra_class_screen.dart';
import '../period/period_tile.dart';
import 'date_appbar_card.dart';

class DayScreen extends StatefulWidget {
  static const route = 'day-view-screen';
  const DayScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DayScreenState createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  late DateTime dateTime;
  @override
  void initState() {
    dateTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        keyString: DayScreen.route,
        title: 'Day view',
        bottom: DateAppbarCard(
          initialDate: dateTime,
          callback: (val) => setState(() => dateTime = val),
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final periods = ref.watch(
            periodsProvider.select(
              (i) => i.reduceList((e) => e.dateTime.isAtSameDayAs(dateTime)),
            ),
          );
          periods.sort((val1, val2) => val1.dateTime.compareTo(val2.dateTime));
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: MyListView(
              key: ValueKey(dateTime),
              keyString: DayScreen.route,
              emptyText:
                  'You have no classes on ${dateTime.format('MMMM dd, yyyy')}',
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: periods.length,
              itemBuilder: (index) => PeriodTile(
                period: periods[index],
                showDate: false,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add actions',
        onPressed: () => Navigator.pushNamed(
          context,
          AddExtraClassScreen.route,
          arguments: dateTime,
        ),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
