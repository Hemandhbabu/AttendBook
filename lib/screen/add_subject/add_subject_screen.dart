import 'package:attend_book/provider/preference_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/custom_app_bar.dart';
import '../../database/entity/subject.dart';
import '../../helpers/type_def_utils.dart';
import '../../provider/add_subject_provider.dart';
import '../../provider/providers.dart';
import '../../tile/tile_callback.dart' show showAlertDialog;
import '../subject_timetable/subject_timetable_screen.dart';
import 'color_picker.dart';
import 'name_input.dart';

class AddSubjectScreen extends ConsumerWidget {
  static const route = 'Add Subject screen';
  const AddSubjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subject = ModalRoute.of(context)?.settings.arguments as Subject?;
    return _Body(
      isNew: subject == null,
      provider: AddSubjectProvider(subject),
      read: ref.read,
    );
  }
}

class _Body extends StatefulWidget {
  final bool isNew;
  final AddSubjectProvider provider;
  final Reader read;

  const _Body({
    Key? key,
    required this.isNew,
    required this.provider,
    required this.read,
  }) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late final AddSubjectProvider _provider;
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;
  late bool changed;
  late final FocusNode noteFN;

  @override
  void initState() {
    changed = false;
    _autovalidateMode = AutovalidateMode.disabled;
    _formKey = GlobalKey<FormState>();
    noteFN = FocusNode();
    _provider = widget.provider;
    super.initState();
  }

  @override
  void dispose() {
    noteFN.dispose();
    super.dispose();
  }

  void save() async {
    final form = _formKey.currentState;
    if (form?.validate() != true) {
      setState(() => _autovalidateMode = AutovalidateMode.always);
      return;
    }
    form?.save();
    final item = await _provider.save(
      context: context,
      pop: () => Navigator.pop(context),
      dao: widget.read(subjectDaoProvider),
      currentTerm: widget.read(currentTermPreferencesProvider),
    );
    if (item == null) return;
    final name = item.name;
    if (widget.isNew) {
      showAlertDialog(
        context: context,
        title: name,
        content: 'Would you like to set timetable for $name ?',
        route: SubjectTimetableScreen.route,
        arguments: item.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return changed
            ? await showAlertDialog(
                  context: context,
                  showTitle: false,
                  content: 'Do you want discard changes and quit editing ?',
                  positiveText: 'Discard',
                  negativeText: 'Keep editing',
                ) ??
                false
            : true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          keyString: null,
          title: '${widget.isNew ? 'Add' : 'Edit'} subject',
          actions: [
            IconButton(
              onPressed: save,
              icon: const Icon(Icons.save_rounded),
              tooltip: 'Save',
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    NameInput(
                      nextFocusNode: noteFN,
                      initialValue: _provider.name,
                      onChange: (_) => changed ? null : changed = true,
                      onSave: _provider.setName,
                    ),
                    const SizedBox(height: 10),
                    ColorPicker(
                      color: _provider.color,
                      defaultColor: Colors.blue,
                      onChanged: (color) {
                        _provider.setColor(color);
                        if (!changed) changed = true;
                      },
                    ),
                    const SizedBox(height: 10),
                    NameInput(
                      minLines: 3,
                      maxLines: 5,
                      focusNode: noteFN,
                      initialValue: _provider.note,
                      onChange: (_) => changed ? null : changed = true,
                      onSave: _provider.setNote,
                      labelText: 'Note',
                      capitalization: TextCapitalization.sentences,
                      validate: (_) => null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
