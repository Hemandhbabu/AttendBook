import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/custom_app_bar.dart';
import '../../../components/my_list_view.dart';
import '../../provider/providers.dart';
import '../add_extra_class/add_extra_class_screen.dart';
import '../period/period_tile.dart';

class AllClassScreen extends StatelessWidget {
  static const route = 'all-class-screen';
  const AllClassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'All classes', keyString: route),
      body: Consumer(
        builder: (context, ref, child) {
          final periods = ref.watch(periodsProvider);
          return MyListView(
            keyString: route,
            padding: const EdgeInsets.only(bottom: 80),
            emptyText: 'You have not attended any classes yet',
            itemCount: periods.length,
            itemBuilder: (index) => PeriodTile(period: periods[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add extra class',
        onPressed: () =>
            Navigator.pushNamed(context, AddExtraClassScreen.route),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
