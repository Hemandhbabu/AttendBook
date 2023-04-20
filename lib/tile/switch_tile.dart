import 'package:flutter/material.dart';

import 'tile.dart';

class SwitchTile extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final String? subtitle;
  final ValueChanged<bool>? onChanged;
  final bool value;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  const SwitchTile({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.onChanged,
    required this.value,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tile(
      margin: margin,
      padding: padding,
      borderRadius: borderRadius,
      leading: leading,
      title: title,
      subtitle: subtitle,
      enabled: onChanged != null,
      tileHeight: null,
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
