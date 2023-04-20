import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'custom_app_bar.dart';

class ElevationBuilder extends ConsumerWidget {
  final String keyString;
  final Widget child;
  const ElevationBuilder({
    super.key,
    required this.keyString,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      type: MaterialType.card,
      elevation: ref.watch(elevatedProvider(keyString)) ? 1.75 : 0,
      child: child,
    );
  }
}
