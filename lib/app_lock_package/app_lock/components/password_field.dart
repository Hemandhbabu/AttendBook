import 'package:flutter/material.dart';

class PasswordField extends AnimatedWidget {
  const PasswordField({
    Key? key,
    required this.length,
    required this.animate,
    required Animation<double> controller,
  }) : super(key: key, listenable: controller);

  final int length;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final controller = listenable as Animation<double>;
    final primary = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        final isColored =
            animate ? index == (controller.value * 8).floor() : index < length;
        return AnimatedContainer(
          width: 14,
          height: 14,
          duration: Duration(milliseconds: animate ? 50 : 250),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isColored ? primary : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              width: 1.5,
              color: isColored ? primary : Colors.grey,
            ),
          ),
        );
      }),
    );
  }
}
