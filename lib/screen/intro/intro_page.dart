import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/preference_provider.dart';
import '../settings/backup.dart';

const primaryColor = Colors.blue;
const secondaryColor = Color(0xFF546E7A);

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Stack(children: const [_Background(), _Body()]));
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Spacer(flex: 5),
          const Text(
            'WELCOME TO',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: secondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Attend Book',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
              fontFamily: 'VarelaRound',
              fontWeight: FontWeight.bold,
              color: secondaryColor,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Track your attendance to maintain record.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Spacer(flex: 3),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Column(
                children: const [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Stay on track with percentage',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'VarelaRound',
                      ),
                    ),
                  ),
                  Divider(height: 3),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                    title: Text(
                      'Restore your previously backed up data '
                      'to manage all attendance and other data in one place.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'VarelaRound',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const _RestoreButton(),
        ],
      ),
    );
  }
}

class _RestoreButton extends StatefulWidget {
  const _RestoreButton({Key? key}) : super(key: key);

  @override
  _RestoreButtonState createState() => _RestoreButtonState();
}

class _RestoreButtonState extends State<_RestoreButton> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer(
            builder: (context, ref, _) => ElevatedButton(
              onPressed: loading
                  ? null
                  : () => RestorePreference.restore(
                        context: context,
                        loadingChange: (value) =>
                            setState(() => loading = value),
                        onDone: () => ref
                            .read(firstLoginPreferencesProvider.notifier)
                            .setBool(true),
                        read: ref.read,
                      ),
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.all(12),
              ),
              child: loading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator.adaptive(strokeWidth: 3),
                    )
                  : const Text(
                      'Restore from old backup',
                      style: TextStyle(fontSize: 17),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Consumer(
            builder: (context, ref, _) => OutlinedButton(
              onPressed: loading
                  ? null
                  : () => ref
                      .read(firstLoginPreferencesProvider.notifier)
                      .setBool(true),
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.all(12),
              ),
              child: const Text(
                'Skip and continue',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          child: Opacity(
            opacity: 0.25,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [primaryColor.withOpacity(0.5), secondaryColor],
                    center: Alignment.topLeft,
                    radius: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(500),
                  )),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Opacity(
            opacity: 0.1,
            child: AspectRatio(
              aspectRatio: 1.25,
              child: Row(
                children: [
                  const Spacer(),
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.only(left: 32, top: 32),
                      decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              primaryColor.withOpacity(0.5),
                              secondaryColor,
                            ],
                            center: Alignment.bottomRight,
                            radius: 1,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(500),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
