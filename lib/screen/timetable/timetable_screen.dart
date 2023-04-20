import 'package:attend_book/components/custom_app_bar.dart';
import 'package:attend_book/components/elevation_builder.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/center_text.dart';
import '../../components/custom_tab_bar.dart';
import '../../helpers/constants.dart';
import '../../provider/providers.dart';
import 'weekday_timetable_card.dart';

class TimetableScreen extends ConsumerWidget {
  static const route = 'timetable-page';
  const TimetableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmpty = ref.watch(
      timetablesProvider.select((value) => value.isEmpty),
    );
    return Scaffold(
      appBar: const CustomAppBar(keyString: null, title: 'Timetables'),
      body: isEmpty
          ? const CenterText('You have no timetable set')
          : DefaultTabController(
              length: 7,
              initialIndex: DateTime.now().weekday - 1,
              child: Column(
                children: [
                  ElevationBuilder(
                    keyString: route,
                    child: CustomTabBar(
                      elevation: 0,
                      backgroundColor:
                          Theme.of(context).appBarTheme.backgroundColor,
                      tabs: weekDays,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: List.generate(
                        7,
                        (index) => WeekdayTimetableCard(weekDay: index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
