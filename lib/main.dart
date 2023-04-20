import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'app_lock_package/preference_provider.dart' as p;
import 'components/main_page.dart';
import 'convert/extension.dart';
import 'database/database.dart';
import 'helpers/enums.dart';
import 'helpers/export_helper.dart';
import 'helpers/material_you_colors.dart';
import 'helpers/notification_selection_actions.dart';
import 'helpers/notification_utils.dart';
import 'helpers/routes.dart';
import 'helpers/theme.dart';
import 'provider/preference_provider.dart';
import 'provider/providers.dart';
import 'screen/intro/intro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final plugin = FlutterLocalNotificationsPlugin();
  final payloadActions = NotificationSelectionActions();
  await _initializeFutterNotification(
    plugin,
    payloadActions.setPayload,
  );
  final prefs = await initializePreferences();
  p.initializePreferences(prefs);
  final db = _DataBaseProvider();
  await db();
  final colors = await getMaterialYouColor();
  final version = await AndroidVersion.getVersion() ?? 19;
  initializeNotification(plugin);
  runApp(
    ProviderScope(
      overrides: [
        _databaseProvider.overrideWithValue(db),
        payloadProvider.overrideWith((ref) => payloadActions),
        isAndroid12Provider.overrideWithValue(version >= VERSION_CODES.S),
      ],
      child: MyApp(palette: colors),
    ),
  );
}

final _databaseProvider = Provider((ref) => _DataBaseProvider());

final isAndroid12Provider = Provider<bool>((ref) => false);

final databaseProvider = Provider<AppDatabase>((ref) {
  return ref.watch(_databaseProvider.select((value) => value.db));
});

class _DataBaseProvider {
  late final AppDatabase _db;

  AppDatabase get db => _db;

  Future<void> call() async {
    _db = await $FloorAppDatabase.databaseBuilder('attendance.db').build();
  }
}

class MyApp extends ConsumerWidget {
  final MaterialYouPalette? palette;
  const MyApp({Key? key, required this.palette}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeMode.values[ref.watch(themePreferencesProvider)];
    final color = ThemeColors.values[ref.watch(themeColorProvider)];
    final useAndroid12Color = ref.watch(useAndroid12ThemePreferencesProvider);
    final isFirst = ref.watch(firstLoginPreferencesProvider);
    return MaterialApp(
      title: 'Attend Book',
      theme: lightThemeData(useAndroid12Color ? palette : null, color.color),
      darkTheme: darkThemeData(useAndroid12Color ? palette : null, color.color),
      themeMode: theme,
      routes: routes,
      home: !isFirst ? const IntroPage() : const MainPage(),
    );
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<void> _initializeFutterNotification(
  FlutterLocalNotificationsPlugin plugin,
  void Function(String payload) setPayload,
) async {
  await _configureLocalTimeZone();
  await plugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('ic_app_notification'),
    ),
    onDidReceiveNotificationResponse: (details) =>
        details.payload?.let(setPayload),
  );
  final launchDetails = await plugin.getNotificationAppLaunchDetails();
  if (launchDetails?.didNotificationLaunchApp ?? false) {
    // Getting the payload data at launching through notification at app start
    if (kDebugMode) print(launchDetails!.notificationResponse?.payload);
    final payload = launchDetails?.notificationResponse?.payload;
    if (payload != null && payload.isNotEmpty) setPayload(payload);
  }
}
