import 'package:attend_book/convert/extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'elevation_builder.dart';

final elevatedProvider =
    StateProvider.family.autoDispose((ref, String key) => false);

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String? title;
  final double? elevation;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Widget Function()? titleBuilder;
  final String? keyString;

  const CustomAppBar({
    Key? key,
    required this.keyString,
    this.title,
    this.bottom,
    this.actions,
    this.leading,
    this.elevation,
    this.titleBuilder,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final hasDrawer = scaffold?.hasDrawer ?? false;
    final canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    final leading = this.leading ??
        (hasDrawer
            ? IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => Scaffold.of(context).openDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              )
            : canPop
                ? useCloseButton
                    ? const CustomCloseButton()
                    : const CustomBackButton()
                : null);
    final appBar = AppBar(
      centerTitle: true,
      elevation: elevation,
      automaticallyImplyLeading: false,
      leading: leading,
      title: titleBuilder?.call() ??
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: Text(title ?? '', key: ValueKey(title)),
          ),
      actions: actions,
      bottom: bottom,
    );
    return keyString?.let(
          (value) => ElevationBuilder(keyString: value, child: appBar),
        ) ??
        appBar;
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  static IconData _getIconData(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Icons.arrow_back_rounded;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Icons.arrow_back_ios_rounded;
    }
  }

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(_getIconData(Theme.of(context).platform)),
        onPressed: () => Navigator.maybePop(context),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      );
}

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return IconButton(
      icon: const Icon(Icons.close_rounded),
      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
      onPressed: () => Navigator.maybePop(context),
    );
  }
}
