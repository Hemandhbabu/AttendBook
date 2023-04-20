import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/custom_app_bar.dart';
import '../../components/my_list_view.dart';
import '../../convert/extension.dart';
import '../../provider/providers.dart';
import 'period_tile.dart';

class PeriodScreen extends StatelessWidget {
  static const route = 'period-screen';
  const PeriodScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as int;
    return Consumer(
      builder: (context, ref, child) {
        final subjectName = ref.watch(
          subjectsProvider.select(
            (value) => value.findItem((element) => element.id == id)?.name,
          ),
        );
        final periods = ref.watch(
          periodsProvider.select(
            (value) => value.reduceList((element) => element.subjectId == id),
          ),
        );
        return Scaffold(
          appBar: CustomAppBar(
            title: '$subjectName\'s periods',
            keyString: route,
          ),
          body: MyListView(
            keyString: route,
            emptyText: 'You have not attended any classes in $subjectName yet',
            itemCount: periods.length,
            itemBuilder: (index) => PeriodTile(
              period: periods[index],
            ),
          ),
        );
      },
    );
  }
}
