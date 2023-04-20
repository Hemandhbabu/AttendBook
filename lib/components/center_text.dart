import 'package:flutter/material.dart';

class CenterText extends StatelessWidget {
  final String text;
  final EdgeInsets? padding;

  const CenterText(
    this.text, {
    Key? key,
    this.padding,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding == null ? const EdgeInsets.all(24) : padding!,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}

class TitleTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const TitleTile({Key? key, required this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: InkWell(
        onTap: onTap,
        highlightColor: Colors.transparent,
        child: ListTile(
          dense: true,
          title: Text(
            title,
            style: const TextStyle(fontSize: 17),
          ),
          trailing: onTap != null
              ? const Icon(Icons.arrow_forward_ios_rounded, size: 16)
              : null,
        ),
      ),
    );
  }
}
