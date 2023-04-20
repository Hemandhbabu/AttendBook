import 'package:flutter/material.dart';

import '../../../helpers/theme.dart';

class AddEditInfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onTap;
  final CrossAxisAlignment alignment;
  const AddEditInfoCard({
    super.key,
    required this.title,
    required this.child,
    this.onTap,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 0,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
            child,
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
