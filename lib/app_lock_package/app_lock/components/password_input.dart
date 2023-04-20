import 'package:flutter/material.dart';

import 'password_button.dart';

typedef StringCallback = void Function(String text);

class PasswordInput extends StatelessWidget {
  final String password;
  final void Function(bool boo) fingerPrintCallback;
  final StringCallback? onChanged;
  const PasswordInput({
    Key? key,
    required this.password,
    required this.onChanged,
    required this.fingerPrintCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: Column(
          children: List.generate(
            4,
            (index1) => Expanded(
              child: Row(
                children: List.generate(
                  3,
                  (index2) {
                    final text = index1 == 3
                        ? index2 == 1
                            ? '0'
                            : null
                        : '${(index1 == 0 ? 1 : index1 == 1 ? 4 : 7) + index2}';
                    return Expanded(
                      child: index1 == 3 && index2 == 0
                          ? FingerPrintButton(onTap: fingerPrintCallback)
                          : PasswordButton(
                              onTap: onChanged == null
                                  ? null
                                  : (text?.isEmpty == true ||
                                          (text == null && password.isEmpty)
                                      ? null
                                      : () => onChanged!(text == null
                                          ? password.substring(
                                              0, password.length - 1)
                                          : password + text)),
                              child: index1 == 3 && index2 == 2
                                  ? const Icon(Icons.backspace_outlined)
                                  : Text(
                                      text!,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
