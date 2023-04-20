import 'package:attend_book/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/center_text.dart';
import '../../components/my_list_view.dart';
import '../../convert/extension.dart';
import '../../convert/today_convert.dart';
import '../../provider/providers.dart';
import 'percent_card.dart';
import 'today_tile.dart';

final _todayProvider = Provider.autoDispose<List<TodayData>>((ref) {
  final now = DateTime.now();
  final timetables = ref.watch(
    timetablesProvider.select(
      (value) => value.reduceList((i) => (i.weekday + 1 == now.weekday)),
    ),
  );
  final periods = ref.watch(
    periodsProvider.select(
      (value) => value.reduceList((i) => i.dateTime.isAtSameDayAs(now)),
    ),
  );
  final subjects = ref.watch(subjectsProvider);
  final data = <TodayData>[];
  for (var item in periods) {
    final subject = subjects.findItem((data) => item.subjectId == data.id);
    if (subject != null) {
      timetables.removeWhere((element) => element.tId == item.timetableId);
      data.add(TodayData(subject: subject, period: item, timetable: null));
    }
  }
  for (var item in timetables) {
    final subject = subjects.findItem((data) => item.subjectId == data.id);
    if (subject != null) {
      data.add(TodayData(subject: subject, period: null, timetable: item));
    }
  }
  data.sort((val1, val2) {
    final d1 = val1.period?.dateTime ?? val1.timetable!.time;
    final d2 = val2.period?.dateTime ?? val2.timetable!.time;
    return d1.inTimeSeconds.compareTo(d2.inTimeSeconds);
  });
  return data;
});

class HomeScreen extends ConsumerWidget {
  static const route = 'home-page';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayDatas = ref.watch(_todayProvider);
    return Scaffold(
      appBar: const CustomAppBar(keyString: route, title: 'Today events'),
      body: todayDatas.isEmpty
          ? Column(
              children: const [
                PercentCard(isClass: true),
                Expanded(
                  child: CenterText('You have no class set today'),
                ),
              ],
            )
          : MyListView(
              keyString: route,
              itemCount: todayDatas.length + 2,
              itemBuilder: (index) => index == 0
                  ? const PercentCard(isClass: true)
                  : index == 1
                      ? const Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Text(
                            'Classes',
                            style: TextStyle(fontSize: 16.5),
                          ),
                        )
                      : TodayTile(todayData: todayDatas[index - 2]),
            ),
    );
  }
}
