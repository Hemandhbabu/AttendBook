import 'package:attend_book/helpers/theme.dart';
import 'package:flutter/material.dart' hide showDatePicker;

import '../../convert/extension.dart';
import '../../widget/my_date_picker.dart';

typedef DateCallback = void Function(DateTime dateTime);

class DateInput extends StatefulWidget {
  final DateTime? dateTime;
  final DateCallback callback;
  final bool isReminder;
  const DateInput({
    Key? key,
    required this.dateTime,
    required this.callback,
    this.isReminder = false,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  late DateTime varDate;

  @override
  void initState() {
    varDate = widget.dateTime ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: varDate,
            firstDate: DateTime(2000),
            lastDate:
                widget.isReminder ? DateTime(2100, 12, 31) : DateTime.now(),
          );
          if (date != null) {
            setState(() => varDate = date);
            widget.callback(date);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Opacity(
                opacity: 0.7,
                child: Text('Date', style: TextStyle(fontSize: 13)),
              ),
              const SizedBox(width: double.infinity, height: 4),
              Text(
                varDate.format('${widget.isReminder ? '' : 'M'}MMM dd, yyyy'),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
