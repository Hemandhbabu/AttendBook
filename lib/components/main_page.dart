import 'dart:async';
import 'dart:convert';

import 'package:attend_book/provider/preference_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../app_lock_package/app_lock.dart';
import '../convert/extension.dart';
import '../convert/today_convert.dart';
import '../helpers/enums.dart';
import '../helpers/type_def_utils.dart';
import '../provider/providers.dart';
import '../screen/add_extra_class/add_extra_class_screen.dart';
import '../screen/add_grade/add_grade_screen.dart';
import '../screen/add_subject/add_subject_screen.dart';
import '../screen/add_timetable/add_time_table_screen.dart';
import '../screen/dashboard/dashboard_screen.dart';
import '../screen/grade/grade_screen.dart';
import '../screen/home/home_screen.dart';
import '../screen/home/today_tile.dart';
import '../screen/subject/subject_screen.dart';
import '../screen/timetable/timetable_screen.dart';
import '../tile/tile.dart';
import 'custom_bottom_navigation_bar.dart';

final verifiedProvider = StateProvider((ref) => false);

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

const _children = [
  HomeScreen(),
  SubjectScreen(),
  TimetableScreen(),
  GradeScreen(),
  DashboardScreen(),
];

class _MainPageState extends ConsumerState<MainPage>
    with WidgetsBindingObserver {
  late int currentIndex;
  AppLifecycleState? _state;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    if (ref.read(hasLockPreferencesProvider)) {
      Future.delayed(Duration.zero, navigateAppLock);
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _state = state;
    debugPrint("app in ${state.name}");
    switch (state) {
      case AppLifecycleState.paused:
        if (ref.read(hasLockPreferencesProvider) &&
            ref.read(verifiedProvider)) {
          timer = Timer(
            Duration(minutes: ref.read(timeoutPreferencesProvider)),
            () {
              timer = null;
              if (_state == AppLifecycleState.paused ||
                  _state == AppLifecycleState.inactive) {
                ref.read(verifiedProvider.notifier).update((state) => false);
                navigateAppLock();
                debugPrint('unverified');
              } else {
                debugPrint('not unverified');
              }
            },
          );
        }
        break;
      case AppLifecycleState.resumed:
        timer?.cancel();
        timer = null;
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<void> navigateAppLock() => Navigator.pushNamed(
        context,
        AppLockPage.route,
        arguments: AppLockArg(
          data: AppLockData.verify(
            onDone: () =>
                ref.read(verifiedProvider.notifier).update((state) => true),
          ),
          useForceClose: true,
        ),
      );

  int? getPayloadArg(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    final data = (json.decode(payload) as List).cast<String>();
    if (data.contains('timetable')) {
      data.remove('timetable');
      return int.tryParse(data[0]);
    }
    return null;
  }

  void showPayloadActions(
    final BuildContext context,
    final String? payload,
    final Reader read,
  ) async {
    await Future.delayed(Duration.zero);
    final arg = getPayloadArg(payload);
    if (arg == null) return;
    final term = ref.read(currentTermPreferencesProvider);
    final timetable =
        await ref.read(timetableDaoProvider).findTimetableWithId(arg, term);
    if (timetable == null) return;
    final subject = await ref
        .read(subjectDaoProvider)
        .findSubjectWithId(timetable.subjectId, term);
    if (subject == null) return;
    final period = (await ref
            .read(periodDaoProvider)
            .findPeriodsWithTimetableId(timetable.tId!, term))
        .findItem((i) => i.dateTime.isAtSameDayAs(DateTime.now()));
    final today =
        TodayData(subject: subject, period: period, timetable: timetable);
    if (!mounted) return;
    read(payloadProvider.notifier).poped();
    showMyAction(
      context,
      SheetTileActionData<PresentStatus>(
        selectedAction: today.period?.status,
        actions: presentStatusActions,
        valueChanged: (context, action) => TodayTile.presentCallback(
          context,
          action,
          today,
          ref.read,
        ),
      ),
      null,
      TodayTile.buildTile(context, today, ref.read),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      tooltip: currentIndex == 0
          ? 'Add actions'
          : currentIndex == 1
              ? 'Add subject'
              : currentIndex == 2
                  ? 'Set timetable'
                  : 'Add grade',
      onPressed: () => currentIndex == 0
          ? Navigator.pushNamed(
              context,
              AddExtraClassScreen.route,
              arguments: DateTime.now(),
            )
          : Navigator.pushNamed(
              context,
              currentIndex == 1
                  ? AddSubjectScreen.route
                  : currentIndex == 2
                      ? AddTimetableScreen.route
                      : AddGradeScreen.route,
            ),
      child: const Icon(Icons.add_rounded),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex == 0) return true;
        setState(() => currentIndex = 0);
        return false;
      },
      child: Scaffold(
        body: Consumer(
          builder: (context, ref, child) {
            showPayloadActions(context, ref.watch(payloadProvider), ref.read);
            return child!;
          },
          child: AnimatedSwitcher(
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.decelerate,
            duration: const Duration(milliseconds: 300),
            child: _children[currentIndex],
          ),
        ),
        floatingActionButton:
            currentIndex > 3 ? null : buildFloatingActionButton(),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) => currentIndex == value
              ? null
              : setState(() => currentIndex = value),
          items: const [
            CustomBottomNavigationBarItem(Icons.event_available_rounded),
            CustomBottomNavigationBarItem(Icons.book_rounded),
            CustomBottomNavigationBarItem(Icons.table_view_rounded),
            CustomBottomNavigationBarItem(Icons.grade_rounded),
            CustomBottomNavigationBarItem(Icons.space_dashboard_rounded),
          ],
        ),
      ),
    );
  }
}
