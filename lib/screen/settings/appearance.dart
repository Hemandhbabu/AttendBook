part of 'settings_screen.dart';

class SystemModePreference extends ConsumerWidget {
  const SystemModePreference({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ThemeMode.values[ref.watch(themePreferencesProvider)];
    return Tile(
      margin: EdgeInsets.zero,
      title: 'Mode',
      tileHeight: null,
      trailing: Text(_getThemeText(theme)),
      borderRadius: BorderRadius.zero,
      pressAction: SheetTileActionData<ThemeMode>(
        selectedAction: theme,
        actions: themeActions,
        valueChanged: (context, value) =>
            ref.read(themePreferencesProvider.notifier).setInt(value.index),
      ),
    );
  }
}

String _getThemeText(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.system:
      return 'System default';
    case ThemeMode.light:
      return 'Light';
    case ThemeMode.dark:
      return 'Dark';
  }
}

class UseAndroid12Preference extends ConsumerWidget {
  const UseAndroid12Preference({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompatibleAndroid12 = ref.watch(isAndroid12Provider);
    if (!isCompatibleAndroid12) return const SizedBox.shrink();
    final useAndroid12Color = ref.watch(useAndroid12ThemePreferencesProvider);
    return SwitchTile(
      title: 'Use android 12 theme',
      value: useAndroid12Color,
      onChanged:
          ref.read(useAndroid12ThemePreferencesProvider.notifier).setBool,
    );
  }
}

class ThemeColorPreference extends ConsumerWidget {
  const ThemeColorPreference({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useAndroid12Color = ref.watch(useAndroid12ThemePreferencesProvider);
    final color = ThemeColors.values[ref.watch(themeColorProvider)];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: useAndroid12Color ? 0 : 56,
      child: useAndroid12Color
          ? const SizedBox.shrink()
          : Tile(
              margin: EdgeInsets.zero,
              title: 'Theme color',
              tileHeight: null,
              trailing: Text(_getColorText(color)),
              borderRadius: BorderRadius.zero,
              pressAction: SheetTileActionData<ThemeColors>(
                selectedAction: color,
                foldable: true,
                actions: ThemeColors.values
                    .map((e) => TileAction(
                          text: _getColorText(e),
                          value: e,
                          color: e.color,
                        ))
                    .toList(),
                valueChanged: (context, value) =>
                    ref.read(themeColorProvider.notifier).setInt(value.index),
              ),
            ),
    );
  }
}

String _getColorText(ThemeColors colors) {
  switch (colors) {
    case ThemeColors.red:
      return 'Red';
    case ThemeColors.purple:
      return 'Purple';
    case ThemeColors.indigo:
      return 'Indigo';
    case ThemeColors.blue:
      return 'Blue';
    case ThemeColors.cyan:
      return 'Cyan';
    case ThemeColors.teal:
      return 'Teal';
    case ThemeColors.green:
      return 'Green';
    case ThemeColors.lime:
      return 'Lime';
    case ThemeColors.amber:
      return 'Amber';
    case ThemeColors.orange:
      return 'Orange';
    case ThemeColors.brown:
      return 'Brown';
    case ThemeColors.blueGrey:
      return 'Blue grey';
  }
}
