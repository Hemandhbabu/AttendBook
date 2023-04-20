import 'package:flutter/material.dart' hide showDatePicker;
import 'package:intl/intl.dart';

import '../../../widget/my_date_picker.dart';

typedef DateCallback = void Function(DateTime dateTime);
const _duration = Duration(days: 1);
const _size = 56.0;

class DateAppbarCard extends StatelessWidget implements PreferredSizeWidget {
  final DateTime initialDate;
  final DateCallback callback;
  const DateAppbarCard({
    Key? key,
    required this.initialDate,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstDate = DateTime(2000);
    final today = DateTime.now();
    String format(DateTime dateTime) => DateFormat.yMMMEd().format(dateTime);
    return Container(
      height: _size,
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              highlightColor: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: firstDate,
                  lastDate: today,
                );
                if (date != null) callback(date);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    key: ValueKey(initialDate),
                    children: [
                      Text(
                        format(initialDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            iconSize: 16,
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: initialDate.subtract(_duration).isBefore(firstDate)
                ? null
                : () => callback(initialDate.subtract(_duration)),
            tooltip: initialDate.subtract(_duration).isBefore(firstDate)
                ? null
                : 'Previous Date ${format(initialDate.subtract(_duration))}',
          ),
          IconButton(
            iconSize: 16,
            icon: const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: initialDate.add(_duration).isAfter(today)
                ? null
                : () => callback(initialDate.add(_duration)),
            tooltip: initialDate.add(_duration).isAfter(today)
                ? null
                : 'Next Date ${format(initialDate.add(_duration))}',
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_size);
}
