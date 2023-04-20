import 'package:flutter/material.dart';

import '../helpers/material_you_colors.dart';

// const _primaryColor = Colors.blue;
// const secondaryColor = Color(0xFFf9a825);
// const secondaryColor = Color(0xFF546E7A);
const _darkBackground = Color(0xFF121212);
const _lightBackground = Color(0xfff3f3f3);
const _darkCard = Color(0xFF212121);
const _lightCard = Color(0xFFFFFFFF);
const _errorColorLight = Color(0xFFB00020);
const _errorColorDark = Color(0xFFCF6679);

ThemeData lightThemeData(MaterialYouPalette? palette, MaterialColor color) =>
    ThemeData(
      primarySwatch: palette?.accent2 ?? color,
      scaffoldBackgroundColor: palette?.neutral1[50] ?? _lightBackground,
      fontFamily: 'VarelaRound',
      colorScheme: ColorScheme.light(
        primary: palette?.accent2 ?? color,
        secondary: palette?.accent2 ?? color,
        error: _errorColorLight,
        background: palette?.neutral1[50] ?? _lightBackground,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: palette?.accent2[10] ?? _lightBackground,
        foregroundColor: palette?.accent2.shade700 ?? Colors.black,
      ),
      listTileTheme: const ListTileThemeData(iconColor: Colors.black),
      pageTransitionsTheme: pageTransitionsTheme,
      cardColor: palette?.neutral1[10] ?? _lightCard,
      cardTheme: cardTheme,
      chipTheme: chipTheme(Brightness.light, palette, color),
      floatingActionButtonTheme:
          floatingActionButtonThemeData(Brightness.light, palette, color),
      inputDecorationTheme: inputDecorationTheme(
        palette?.neutral1[10] ?? _lightCard,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      bottomSheetTheme: bottomSheetThemeData(Brightness.light, palette),
      bottomNavigationBarTheme:
          bottomNavigationBarThemeData(Brightness.light, palette, color),
    );

ThemeData darkThemeData(MaterialYouPalette? palette, MaterialColor color) =>
    ThemeData(
      primarySwatch: palette?.accent2 ?? color,
      scaffoldBackgroundColor: palette?.neutral1.shade900 ?? _darkBackground,
      fontFamily: 'VarelaRound',
      colorScheme: ColorScheme.dark(
        primary: palette?.accent2 ?? color,
        background: palette?.neutral1.shade900 ?? _darkBackground,
        secondary: palette?.accent2 ?? color,
        error: _errorColorDark,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: palette?.neutral2.shade800 ?? _darkBackground,
        foregroundColor: palette?.accent2.shade50 ?? Colors.white,
      ),
      toggleableActiveColor: palette?.accent2 ?? color,
      pageTransitionsTheme: pageTransitionsTheme,
      cardColor: palette?.neutral1.shade800 ?? _darkCard,
      chipTheme: chipTheme(Brightness.dark, palette, color),
      cardTheme: cardTheme,
      floatingActionButtonTheme:
          floatingActionButtonThemeData(Brightness.dark, palette, color),
      inputDecorationTheme: inputDecorationTheme(
        palette?.neutral1.shade800 ?? _darkCard,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      bottomSheetTheme: bottomSheetThemeData(Brightness.dark, palette),
      bottomNavigationBarTheme:
          bottomNavigationBarThemeData(Brightness.dark, palette, color),
    );

const borderRadius = BorderRadius.all(Radius.circular(8));
const shape = RoundedRectangleBorder(borderRadius: borderRadius);
const cardTheme = CardTheme(shape: shape);

ChipThemeData chipTheme(
        Brightness brightness, MaterialYouPalette? palette, Color color) =>
    ChipThemeData.fromDefaults(
      secondaryColor: palette == null
          ? color
          : brightness == Brightness.light
              ? palette.accent2.shade700
              : palette.accent2.shade100,
      brightness: brightness,
      labelStyle: const TextStyle(fontFamily: 'VarelaRound'),
    );

const pageTransitionsTheme = PageTransitionsTheme(builders: {
  TargetPlatform.android: CustomPageTransitionBuilder(),
  TargetPlatform.iOS: CustomPageTransitionBuilder(),
});

inputDecorationTheme(Color fillColor) => InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      border: const UnderlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none,
      ),
    );

floatingActionButtonThemeData(
        Brightness brightness, MaterialYouPalette? palette, Color color) =>
    FloatingActionButtonThemeData(
      foregroundColor: palette == null
          ? Colors.white
          : brightness == Brightness.light
              ? palette.accent2.shade700
              : palette.accent2.shade100,
      backgroundColor: palette == null
          ? color
          : brightness == Brightness.light
              ? palette.accent2.shade100
              : palette.accent2.shade700,
    );

bottomSheetThemeData(Brightness brightness, MaterialYouPalette? palette) =>
    BottomSheetThemeData(
      backgroundColor: brightness == Brightness.dark
          ? palette == null
              ? _darkCard
              : palette.neutral1.shade800
          : palette == null
              ? _lightCard
              : palette.neutral1[10],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
    );

bottomNavigationBarThemeData(
        Brightness brightness, MaterialYouPalette? palette, Color color) =>
    BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(
        color: palette == null
            ? color
            : brightness == Brightness.light
                ? palette.accent2.shade700
                : palette.accent2.shade100,
      ),
      unselectedIconTheme: IconThemeData(
        color: palette == null
            ? (brightness == Brightness.light ? Colors.black : Colors.white)
                .withOpacity(0.75)
            : palette.accent2.shade400,
      ),
      backgroundColor: palette == null
          ? brightness == Brightness.light
              ? _lightCard
              : _darkCard
          : brightness == Brightness.light
              ? palette.accent2[10]
              : palette.neutral2.shade800,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    );

const _curve = Curves.decelerate;

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  const CustomPageTransitionBuilder();
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (!route.canPop) {
      return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: _curve),
          child: child);
    }
    return SlideTransition(
      position: Tween(begin: const Offset(1, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: animation, curve: _curve)),
      child: child,
    );
  }
}
