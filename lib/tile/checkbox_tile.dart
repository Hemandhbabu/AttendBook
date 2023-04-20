import 'package:flutter/material.dart';

import 'tile.dart';

class CheckboxTile extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final String? subtitle;
  final ValueChanged<bool?>? onChanged;
  final bool? value;
  final bool tristate;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  const CheckboxTile({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.onChanged,
    required this.value,
    this.tristate = false,
    this.margin = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  void _handleValueChange() {
    assert(onChanged != null);
    switch (value) {
      case false:
        onChanged!(true);
        break;
      case true:
        onChanged!(tristate ? null : false);
        break;
      case null:
        onChanged!(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tile(
      margin: margin,
      borderRadius: borderRadius,
      leading: leading,
      title: title,
      subtitle: subtitle,
      tileHeight: null,
      enabled: onChanged != null,
      onTap: _handleValueChange,
      trailing: Checkbox(
        value: value,
        onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        tristate: tristate,
      ),
    );
  }
}
