import 'dart:io';

import 'package:encrypt/encrypt.dart' as en;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Font family is set as "VarelaRound"
const fontFamily = 'VarelaRound';
const titleWeight = FontWeight.normal;
const contentWeight = FontWeight.normal;

void backupAction({
  required BuildContext context,
  required String backupData,
  required Future<String?> Function() buildLocalFolder,
  required String driveFolder,
  required String localFile,
  required String driveFile,
  required int androidVersion,
  required void Function(bool) loadingChange,
}) =>
    _LocalBackup.localBackup(
      backupData: backupData,
      buildLocalFolder: buildLocalFolder,
      fileName: localFile,
      androidVersion: androidVersion,
      confirmRequest: () => _confirmRequest(context, true),
      onStart: () => loadingChange(true),
      onDone: (file) {
        loadingChange(false);
        _showSnackBar(
          context: context,
          content: 'Backup completed successfully.',
        );
      },
      onError: (error) {
        loadingChange(false);
        _showSnackBar(context: context, content: error);
      },
    );

Future<void> restoreAction({
  required BuildContext context,
  required Future<String?> Function() buildLocalFolder,
  required String driveFile,
  required int androidVersion,
  required Future<bool?> Function(String) restore,
  required void Function(bool) loadingChange,
  required void Function() onDone,
}) =>
    _LocalRestore.localRestore(
      context: context,
      buildLocalFolder: buildLocalFolder,
      androidVersion: androidVersion,
      confirmRequest: () => _confirmRequest(context, false),
      onStart: () => loadingChange(true),
      onDone: (data) async {
        final isDone = (await restore(data)) ?? false;
        if (isDone) onDone();
        loadingChange(false);
        _showSnackBar(
          context: context,
          content: isDone
              ? 'Restore completed successfully.'
              : 'Error while restoring',
        );
      },
      onError: (error) {
        loadingChange(false);
        _showSnackBar(context: context, content: error);
      },
    );

void _showSnackBar({
  required BuildContext context,
  required final String content,
  final String actionText = 'Undo',
  final VoidCallback? action,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.removeCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: const TextStyle(
          fontFamily: fontFamily,
          fontWeight: contentWeight,
          fontSize: 15,
        ),
      ),
      action: action != null
          ? SnackBarAction(label: actionText, onPressed: action)
          : null,
    ),
  );
}

Future<bool> _confirmRequest(BuildContext context, bool backup) async {
  final message = backup
      ? 'Do you want to backup current data ?'
      : 'Do you want to restore the previous backup ?';
  final request = await _showCustomDialog<bool>(
    context: context,
    title: 'Are you sure ?',
    content: message,
    actionsBuilder: (context) => [
      _CustomDialogAction(
        text: 'No',
        onTap: () => Navigator.pop(context, false),
      ),
      _CustomDialogAction(
        text: 'Yes',
        onTap: () => Navigator.pop(context, true),
      ),
    ],
  );
  return request ?? false;
}

class _MyEncrypt {
  static final _key = en.Key.fromLength(32);
  static final _iv = en.IV.fromLength(16);
  static final _encrypter = en.Encrypter(en.AES(_key));

  static String encryptAES(String text) =>
      _encrypter.encrypt(text, iv: _iv).base16;

  static String decryptAES(String encrypt) =>
      _encrypter.decrypt16(encrypt, iv: _iv);
}

Future<T?> _showCustomDialog<T>({
  required BuildContext context,
  String? title,
  required String content,
  Widget Function(TextStyle style)? body,
  TextAlign contentAlign = TextAlign.center,
  required List<_CustomDialogAction<T>> Function(BuildContext context)
      actionsBuilder,
}) =>
    showDialog<T>(
      context: context,
      useSafeArea: true,
      builder: (context) {
        final actions = actionsBuilder(context);
        return AlertDialog(
          title: title != null
              ? Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: titleWeight,
                    fontFamily: fontFamily,
                    fontSize: 20,
                  ),
                )
              : null,
          content: body != null
              ? body(const TextStyle(
                  fontWeight: contentWeight,
                  fontSize: 17,
                  fontFamily: fontFamily,
                ))
              : Text(
                  content,
                  textAlign: contentAlign,
                  style: const TextStyle(
                    fontWeight: contentWeight,
                    fontSize: 17,
                    fontFamily: fontFamily,
                  ),
                ),
          actions: actions.map((e) => _buildAction(context, e)).toList(),
        );
      },
    );

Widget _buildAction<T>(BuildContext context, _CustomDialogAction<T> value) {
  return TextButton(
    onPressed: value.onTap,
    child: Text(
      value.text,
      style: TextStyle(
        color: value.color,
        fontWeight: contentWeight,
        fontSize: 15,
        fontFamily: fontFamily,
      ),
    ),
  );
}

class _CustomDialogAction<T> {
  final String text;
  final Color? color;
  final VoidCallback? onTap;

  _CustomDialogAction({
    required this.text,
    this.color,
    required this.onTap,
  });
}

class _LocalBackup {
  static void localBackup({
    required String backupData,
    required Future<String?> Function() buildLocalFolder,
    required String fileName,
    required int androidVersion,
    required Future<bool> Function() confirmRequest,
    required VoidCallback onStart,
    required void Function(File) onDone,
    required void Function(String) onError,
  }) async {
    final confirm = await confirmRequest();
    if (!confirm) return;
    var granted = await (androidVersion > 29
            ? Permission.manageExternalStorage
            : Permission.storage)
        .isGranted;
    if (!granted) {
      granted = (await (androidVersion > 29
                  ? Permission.manageExternalStorage
                  : Permission.storage)
              .request())
          .isGranted;
    }
    if (granted) {
      onStart();
      try {
        final folderName = await buildLocalFolder();
        if (folderName != null) {
          final file = File('$folderName/$fileName');
          final encrypt = _MyEncrypt.encryptAES(backupData);
          final result = await file.writeAsBytes(encrypt.codeUnits);
          onDone(result);
        } else {
          throw 'Storage permission required';
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        onError(e.toString());
      }
    } else {
      onError('Storage permission required');
    }
  }
}

class _LocalRestore {
  static Future<String?> _pickLocalFile({
    required BuildContext context,
    required String folderName,
    required Iterable<String> files,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, controller) {
          return ListView(
            shrinkWrap: true,
            controller: controller,
            children: [
              const SizedBox(height: 16),
              Align(
                child: Container(
                  height: 2,
                  width: 32,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: const [
                  SizedBox(width: 16),
                  CloseButton(),
                  Expanded(
                    child: Text(
                      'Select backup file',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: titleWeight,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ),
                  SizedBox(width: 56),
                ],
              ),
              const SizedBox(height: 8),
              if (files.isEmpty)
                const SizedBox(
                  height: 250,
                  child: Center(
                    child: Text(
                      'You have no backup files',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: titleWeight,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ),
                ),
              ...files.map(
                (e) => ListTile(
                  title: Text(
                    e,
                    style: const TextStyle(
                      fontWeight: contentWeight,
                      fontSize: 17,
                      fontFamily: fontFamily,
                    ),
                  ),
                  onTap: () => Navigator.pop(context, '$folderName/$e'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Pick file',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: titleWeight,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      final path = result.files.single.path;
                      if (path != null && path.endsWith('.bk')) {
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context, path);
                      }
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static Future<void> localRestore({
    required BuildContext context,
    required Future<String?> Function() buildLocalFolder,
    required int androidVersion,
    required Future<bool> Function() confirmRequest,
    required VoidCallback onStart,
    required Future<void> Function(String) onDone,
    required void Function(String) onError,
  }) async {
    final confirm = await confirmRequest();
    if (!confirm) return;
    var granted = await (androidVersion > 29
            ? Permission.manageExternalStorage
            : Permission.storage)
        .isGranted;
    if (!granted) {
      granted = (await (androidVersion > 29
                  ? Permission.manageExternalStorage
                  : Permission.storage)
              .request())
          .isGranted;
    }
    if (granted) {
      try {
        final folderName = await buildLocalFolder();
        if (folderName != null) {
          final list = Directory(folderName)
              .listSync(recursive: true, followLinks: false)
              .map((e) => e.path.replaceAll('$folderName/', ''))
              .toList();
          list.removeWhere((e) => e.startsWith('.'));
          final filePath = await _pickLocalFile(
            context: context,
            folderName: folderName,
            files: list,
          );
          if (filePath != null) {
            onStart();
            final file = File(filePath);
            await onDone(_MyEncrypt.decryptAES(await file.readAsString()));
          }
        } else {
          throw 'Storage permission required';
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        onError(e.toString());
      }
    } else {
      onError('Storage permission required');
    }
  }
}
