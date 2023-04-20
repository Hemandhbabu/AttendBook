import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final TabController? controller;
  final List<String> tabs;
  final double elevation;
  final double padding;
  final double height;
  final bool bigText;
  const CustomTabBar({
    Key? key,
    this.backgroundColor = Colors.transparent,
    this.controller,
    required this.tabs,
    this.elevation = 0,
    this.bigText = false,
    double? padding,
  })  : height = bigText ? 26 : 24,
        padding = padding ?? (bigText ? 16 : 4),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = theme.colorScheme.secondary;
    return SizedBox(
      height: height + padding,
      child: Material(
        elevation: elevation,
        color: backgroundColor,
        child: Theme(
          data: theme.copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: height,
              width: double.infinity,
              child: TabBar(
                isScrollable: true,
                controller: controller,
                labelColor: selected,
                labelStyle: TextStyle(
                  fontSize: bigText ? 16.5 : 15.5,
                  fontFamily: 'VarelaRound',
                ),
                unselectedLabelColor: theme.iconTheme.color,
                indicator: _TabDecoration(color: selected, height: 2.5),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: tabs.map((e) => Text(e)).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height + padding);
}

class _TabDecoration extends Decoration {
  final double height;
  final Color color;

  const _TabDecoration({this.height = 2.5, required this.color});
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _TabPainter(onChanged, height: height, color: color);
}

class _TabPainter extends BoxPainter {
  final double height;
  final Color color;

  _TabPainter(
    VoidCallback? onChanged, {
    required this.height,
    required this.color,
  }) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(height > 0);

    //offset is the position from where the decoration should be drawn.
    //configuration.size tells us about the height and width of the tab.
    final width = configuration.size!.width / 4;
    final mysize = Size(width, height);

    // final width = height * 4;
    // final mysize = Size(width, height);

    Offset myoffset = Offset(
      offset.dx + configuration.size!.width / 2 - width / 2,
      offset.dy + (configuration.size!.height - height),
    );

    final Rect rect = myoffset & mysize;
    final Paint paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect,
          Radius.circular(height / 2),
          // topRight: const Radius.circular(15),
        ),
        paint);
  }
}
