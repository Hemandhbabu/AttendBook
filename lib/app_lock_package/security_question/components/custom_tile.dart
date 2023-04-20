import 'package:attend_book/convert/extension.dart';

import '../../../helpers/theme.dart' as theme;
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final Color? leadingColor;
  final IconData? leadingIcon;
  final String? leadingSymbol;
  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? color;
  final Color? titleColor;
  final double elevation;
  final double titleSize;
  final double subtitleSize;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final int? maxLines;
  final ShapeBorder shape;
  const CustomTile({
    super.key,
    this.leadingColor,
    this.leadingIcon,
    this.leadingSymbol,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.color,
    this.elevation = 0,
    this.titleSize = 16.5,
    this.subtitleSize = 13,
    this.padding = EdgeInsets.zero,
    this.titleColor,
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.maxLines,
    this.shape = theme.shape,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle?.isNotEmpty == true ? this.subtitle : null;
    return Card(
      elevation: elevation,
      color: color,
      shape: shape,
      margin: margin,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        customBorder: shape,
        child: Padding(
          padding: padding,
          child: ListTile(
            shape: shape,
            leading: leadingIcon != null || leadingSymbol != null
                ? Container(
                    height: 48,
                    width: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: leadingColor?.withOpacity(0.05),
                    ),
                    child: leadingIcon != null
                        ? Icon(leadingIcon, color: leadingColor)
                        : FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                leadingSymbol!,
                                maxLines: 1,
                                style: TextStyle(
                                  color: leadingColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                  )
                : leading != null
                    ? leading!
                    : null,
            title: title != null
                ? Text(
                    title!,
                    maxLines: maxLines,
                    overflow: maxLines?.let((value) => TextOverflow.ellipsis),
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  )
                : null,
            subtitle: subtitle != null
                ? Text(
                    subtitle,
                    maxLines: maxLines,
                    overflow: maxLines?.let((value) => TextOverflow.ellipsis),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: subtitleSize,
                    ),
                  )
                : null,
            trailing: trailing,
          ),
        ),
      ),
    );
  }
}
