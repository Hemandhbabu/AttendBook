import 'dart:math' as math;

import 'package:flutter/material.dart';

const _duration = Duration(milliseconds: 800);
const _curve = Curves.fastOutSlowIn;
const deg_90 = math.pi / 2;
const deg_360 = math.pi * 2;
typedef TextBuilderWithValue = String Function(double value);
typedef SubtextBuilder = String Function();

class LeadingProgress extends StatelessWidget {
  const LeadingProgress({
    Key? key,
    required this.value,
    this.textBuilder,
    this.subtextBuilder,
    this.radius = 21,
  }) : super(key: key);

  final double value;
  final TextBuilderWithValue? textBuilder;
  final SubtextBuilder? subtextBuilder;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      child: Center(
        child: _MyProgress(
          textBuilder: textBuilder,
          subtextBuilder: subtextBuilder,
          value: value,
          widthPercent: 15,
        ),
      ),
    );
  }
}

class MyProgressbar extends StatefulWidget {
  final double value;
  final bool initialAnimate;
  final TextBuilderWithValue? textBuilder;
  final SubtextBuilder? subtextBuilder;
  final double widthPercent;
  final double? unselectedWidthPercent;

  const MyProgressbar({
    Key? key,
    required this.value,
    this.initialAnimate = false,
    this.textBuilder,
    this.subtextBuilder,
    this.widthPercent = 12,
    this.unselectedWidthPercent,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyProgressbarState createState() => _MyProgressbarState();
}

class _MyProgressbarState extends State<MyProgressbar> {
  var begin = 0.0;
  var end = 1.0;
  bool initialized = false;
  @override
  void initState() {
    end = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MyProgressbar oldWidget) {
    if (oldWidget.value != widget.value) {
      setState(() {
        begin = oldWidget.value;
        end = widget.value;
        if (!initialized) initialized = true;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      curve: _curve,
      duration:
          !initialized && !widget.initialAnimate ? Duration.zero : _duration,
      builder: (context, val, _) => _MyProgress(
        widthPercent: widget.widthPercent,
        unselectedWidthPercent: widget.unselectedWidthPercent,
        textBuilder: widget.textBuilder,
        subtextBuilder: widget.subtextBuilder,
        value: val,
      ),
    );
  }
}

class MySingleProgressbar extends StatelessWidget {
  final double value;
  final TextBuilderWithValue? textBuilder;
  final SubtextBuilder? subtextBuilder;

  const MySingleProgressbar({
    Key? key,
    required this.value,
    this.textBuilder,
    this.subtextBuilder,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return _MyProgress(
      value: value,
      textBuilder: textBuilder,
      subtextBuilder: subtextBuilder,
    );
  }
}

class _MyProgress extends StatelessWidget {
  final double value;
  final double widthPercent;
  final double? unselectedWidthPercent;
  final TextBuilderWithValue? textBuilder;
  final SubtextBuilder? subtextBuilder;

  const _MyProgress({
    Key? key,
    required this.value,
    this.widthPercent = 12,
    this.unselectedWidthPercent,
    required this.textBuilder,
    required this.subtextBuilder,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const fraction = 0.7;
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _MyPainter(
          value: value,
          widthPercent: widthPercent,
          unselectedWidthPercent: unselectedWidthPercent ?? widthPercent * 0.9,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final text = textBuilder != null
                ? textBuilder!(value)
                : '${(value * 100).ceil()} %';
            final subtext = subtextBuilder != null ? subtextBuilder!() : '';
            return Center(
              child: SizedBox(
                width: constraints.biggest.shortestSide * fraction,
                height: constraints.biggest.shortestSide * fraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (text.isNotEmpty)
                      Expanded(
                        flex: 30,
                        child: FittedBox(child: SizedBox(child: Text(text))),
                      ),
                    if (subtext.isNotEmpty)
                      Expanded(
                        flex: 13,
                        child: FittedBox(child: SizedBox(child: Text(subtext))),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  final double value;
  final double widthPercent;
  final double unselectedWidthPercent;
  const _MyPainter({
    required this.value,
    required this.widthPercent,
    required this.unselectedWidthPercent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final width = radius * (widthPercent / 100);
    final unselectedWidth = radius * (unselectedWidthPercent / 100);
    canvas.drawCircle(
      center,
      radius,
      progressPaint
        ..color = Colors.green.withOpacity(0.16)
        ..strokeWidth = unselectedWidth,
    );
    canvas.drawArc(
      rect,
      -deg_90,
      deg_360 * value,
      false,
      progressPaint
        ..color = Colors.green
        ..strokeWidth = width,
    );
    // if (showInnerProgress) {
    //   final smallRect = Rect.fromCircle(center: center, radius: radius * 0.75);
    //   canvas.drawCircle(
    //       center,
    //       radius * 0.75,
    //       progressPaint
    //         ..color = Colors.green.withOpacity(0.16)
    //         ..strokeWidth = width * 0.9);
    //   canvas.drawArc(
    //       smallRect,
    //       -deg_90,
    //       deg_360 * (requiredValue / 100),
    //       false,
    //       progressPaint
    //         ..color = Colors.green.withOpacity(0.75)
    //         ..strokeWidth = width);
    // }
  }

  @override
  bool shouldRepaint(_MyPainter oldDelegate) => oldDelegate.value != value;
}

// class MyLinearProgressbar extends StatelessWidget {
//   final double minHeight;
//   final double value;
//   final Alignment alignment;
//   const MyLinearProgressbar({
//     Key? key,
//     this.minHeight = 4.0,
//     required this.value,
//     this.alignment = Alignment.centerLeft,
//   }) : super(key: key);

//   static const borderRadius = BorderRadius.all(Radius.circular(100));

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints.tightFor(
//         width: double.infinity,
//         height: minHeight,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.green.withAlpha(38),
//         borderRadius: borderRadius,
//       ),
//       child: FractionallySizedBox(
//         widthFactor: value,
//         alignment: alignment,
//         child: Container(
//           decoration: const BoxDecoration(
//             color: Colors.green,
//             borderRadius: borderRadius,
//           ),
//         ),
//       ),
//     );
//   }
// }
