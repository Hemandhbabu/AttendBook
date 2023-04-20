import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomTextField extends ConsumerWidget {
  const CustomTextField({
    Key? key,
    required AutoDisposeStateProvider<String?> provider,
    this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.nextFocusNode,
    this.validator,
    this.minLines,
    this.maxLines,
    this.capitalization = TextCapitalization.sentences,
    this.inputFormatters,
    this.maxLength,
    this.autoFocus = false,
    this.icon,
    this.trailingAction,
    this.textInputAction,
    this.errorText,
    this.onFieldSubmitted,
    this.textAlign = TextAlign.start,
    this.contentPadding,
    this.style,
    this.labelStyle,
    this.fillColor,
  })  : _provider = provider,
        _controller = null,
        super(key: key);

  const CustomTextField.controller({
    Key? key,
    this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.nextFocusNode,
    this.validator,
    this.minLines,
    this.maxLines,
    this.capitalization = TextCapitalization.sentences,
    this.inputFormatters,
    this.maxLength,
    this.autoFocus = false,
    this.icon,
    this.trailingAction,
    this.textInputAction,
    required TextEditingController controller,
    this.errorText,
    this.onFieldSubmitted,
    this.textAlign = TextAlign.start,
    this.contentPadding,
    this.style,
    this.labelStyle,
    this.fillColor,
  })  : _controller = controller,
        _provider = null,
        super(key: key);

  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final FormFieldValidator<String>? validator;
  final String? labelText;
  final String? hintText;
  final int? minLines, maxLines;
  final TextCapitalization capitalization;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool autoFocus;
  final AutoDisposeStateProvider<String?>? _provider;
  final IconData? icon;
  final VoidCallback? trailingAction;
  final TextInputAction? textInputAction;
  final TextEditingController? _controller;
  final String? errorText;
  final VoidCallback? onFieldSubmitted;
  final TextAlign textAlign;
  final EdgeInsets? contentPadding;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final Color? fillColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (_provider != null) ref.listen<String?>(_provider!, (previous, next) {});
    return TextFormField(
      minLines: minLines,
      maxLines: maxLines,
      initialValue: _controller == null ? ref.read(_provider!) : null,
      controller: _controller,
      autofocus: autoFocus,
      focusNode: focusNode,
      textAlign: textAlign,
      style: style,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: labelStyle,
        labelStyle: labelStyle,
        contentPadding: contentPadding,
        fillColor: fillColor,
        errorText: errorText?.isNotEmpty == true ? errorText : null,
        suffixIcon: trailingAction != null && icon != null
            ? IconButton(
                onPressed: trailingAction,
                icon: Icon(icon),
              )
            : null,
      ),
      keyboardType: maxLines != null && maxLines! > 1
          ? TextInputType.multiline
          : keyboardType,
      textInputAction: nextFocusNode == null
          ? textInputAction ??
              (minLines == null || minLines! < 2
                  ? TextInputAction.done
                  : TextInputAction.newline)
          : TextInputAction.next,
      textCapitalization: capitalization,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      validator: validator,
      onChanged: _provider != null
          ? (value) => ref.read(_provider!.notifier).state = value.trim()
          : null,
      onFieldSubmitted: (_) {
        onFieldSubmitted?.call();
        nextFocusNode?.requestFocus();
      },
    );
  }
}
