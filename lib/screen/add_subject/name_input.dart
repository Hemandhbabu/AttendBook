import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef StringCallback = void Function(String text);

class NameInput extends StatelessWidget {
  const NameInput({
    Key? key,
    this.focusNode,
    this.nextFocusNode,
    required this.onChange,
    this.labelText = 'Name',
    required this.onSave,
    this.initialValue,
    this.validate,
    this.minLines,
    this.maxLines,
    this.capitalization = TextCapitalization.words,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLength,
    this.autoFocus = false,
  }) : super(key: key);

  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final FormFieldValidator<String>? validate;
  final StringCallback onChange;
  final StringCallback onSave;
  final String labelText;
  final String? initialValue;
  final int? minLines, maxLines;
  final TextCapitalization capitalization;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: minLines,
      maxLines: maxLines,
      initialValue: initialValue,
      autofocus: autoFocus,
      focusNode: focusNode,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: maxLines != null && maxLines! > 1
          ? TextInputType.multiline
          : keyboardType,
      textInputAction: nextFocusNode == null
          ? minLines == null || minLines! < 2
              ? TextInputAction.done
              : TextInputAction.newline
          : TextInputAction.next,
      textCapitalization: capitalization,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      validator: validate ??
          (val) {
            val = val?.trim();
            if (val == null || val.isEmpty != false) {
              return '$labelText required!';
            }
            if (val.length < 4) return '$labelText must 4 character length';
            return null;
          },
      onChanged: onChange,
      onSaved: (val) => val == null ? null : onSave(val),
      onFieldSubmitted: (_) => nextFocusNode?.requestFocus(),
    );
  }
}
