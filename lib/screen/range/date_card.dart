import 'package:flutter/material.dart' hide showDateRangePicker;

import '../../../convert/extension.dart';
import '../../../widget/my_date_picker.dart';

const _size = 60.0;

class DateCard extends StatelessWidget implements PreferredSizeWidget {
  final DateTimeRange range;
  final ValueChanged<DateTimeRange> onChanged;
  const DateCard({
    Key? key,
    required this.range,
    required this.onChanged,
  }) : super(key: key);

  static void pickRange(BuildContext context, DateTimeRange initial,
      ValueChanged<DateTimeRange> onChanged) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
      initialDateRange: initial,
    );
    if (picked != null) {
      final start = picked.start.copyWith(hour: 0, minute: 0, second: 0);
      var end = picked.end.copyWith(hour: 23, minute: 59, second: 59);
      if (end.isAfter(now)) end = now;
      onChanged(DateTimeRange(start: start, end: end));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _size,
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 2),
      child: InkWell(
        highlightColor: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: () => pickRange(context, range, onChanged),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: _DateText(
                title: 'From',
                dateTime: range.start,
              ),
            ),
            Expanded(
              flex: 3,
              child: _DateText(
                title: 'To',
                dateTime: range.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_size);
}

class _DateText extends StatelessWidget {
  final String title;
  final DateTime dateTime;
  const _DateText({
    Key? key,
    required this.title,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = dateTime.format('MMM d, yyyy');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.6,
              child: Text(title, style: const TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 4.0),
            Text(date, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
