import 'package:attend_book/provider/preference_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/custom_app_bar.dart';
import '../../components/my_dropdown.dart';
import '../../database/entity/grade.dart';
import '../../helpers/enums.dart';
import '../../helpers/type_def_utils.dart';
import '../../provider/add_grade_provider.dart';
import '../../provider/providers.dart';
import '../../tile/tile.dart';
import '../../tile/tile_callback.dart';
import '../add_subject/name_input.dart';
import 'date_input.dart';

class AddGradeScreen extends ConsumerWidget {
  const AddGradeScreen({Key? key}) : super(key: key);

  static const route = 'add-grade-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final grade = arg is Grade ? arg : null;
    final subId = arg is int ? arg : null;
    return _Body(
      isNew: grade == null,
      read: ref.read,
      provider: AddGradeProvider(
        loadedGrade: grade,
        subjectId: subId,
        read: ref.read,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final bool isNew;
  final AddGradeProvider provider;
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
  late final AddGradeProvider _provider;
  late final GlobalKey<FormState> _formKey;
  late AutovalidateMode _autovalidateMode;
  late bool changed;
  late GradingSystem _gradingSystem;
  late final FocusNode creditsFN, noteFN;

  @override
  void initState() {
    changed = false;
    _autovalidateMode = AutovalidateMode.disabled;
    _formKey = GlobalKey<FormState>();
    _provider = widget.provider;
    _gradingSystem = _provider.gradingSystem;
    creditsFN = FocusNode();
    noteFN = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    creditsFN.dispose();
    noteFN.dispose();
    super.dispose();
  }

  void save() async {
    if (_provider.subjectId == -1) {
      MyTileCallback.showSnackbar(
          context: context, message: 'You have not selected any subjects yet.');
      return;
    }
    final form = _formKey.currentState;
    if (form?.validate() != true) {
      setState(() => _autovalidateMode = AutovalidateMode.always);
      return;
    }
    form?.save();
    final message = await _provider.save(
      pop: () => Navigator.pop(context),
      dao: widget.read(gradeDaoProvider),
      currentTerm: widget.read(currentTermPreferencesProvider),
    );
    MyTileCallback.showSnackbar(context: context, message: message);
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
          title: '${widget.isNew ? 'Add' : 'Edit'} grade',
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
                    DateInput(
                      dateTime: _provider.dateTime,
                      callback: (val) {
                        _provider.dateTime = val;
                        if (!changed) changed = true;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: NameInput(
                            nextFocusNode: creditsFN,
                            initialValue: _provider.gradeFieldValue,
                            onChange: (_) => changed ? null : changed = true,
                            onSave: (val) =>
                                _provider.setGradeValue(double.parse(val)),
                            keyboardType: TextInputType.number,
                            labelText: 'Grade',
                            capitalization: TextCapitalization.characters,
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Grade required';
                              }
                              switch (_gradingSystem) {
                                case GradingSystem.zeroToFive:
                                  if (double.tryParse(value) == null) {
                                    return 'Enter a valid grade';
                                  }
                                  if (double.parse(value) > 5) {
                                    return 'Enter grade between 0 to 5';
                                  }
                                  break;
                                case GradingSystem.zeroToTen:
                                  if (double.tryParse(value) == null) {
                                    return 'Enter a valid grade';
                                  }
                                  if (double.parse(value) > 10) {
                                    return 'Enter grade between 0 to 10';
                                  }
                                  break;
                                case GradingSystem.zeroToHundred:
                                  if (double.tryParse(value) == null) {
                                    return 'Enter a valid grade';
                                  }
                                  if (double.parse(value) > 100) {
                                    return 'Enter grade between 0 to 100';
                                  }
                                  break;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: NameInput(
                            focusNode: creditsFN,
                            nextFocusNode: noteFN,
                            onChange: (_) => changed ? null : changed = true,
                            onSave: (val) => val.isEmpty
                                ? null
                                : _provider.setCredits(int.parse(val)),
                            initialValue: _provider.credits?.toString(),
                            keyboardType: TextInputType.number,
                            labelText: 'Credits',
                            validate: (value) {
                              if (value == null || value.isEmpty) return null;
                              if (int.tryParse(value) == null) {
                                return 'Enter a valid number';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Consumer(
                      builder: (context, ref, _) => MyDropdown(
                        items: ref
                            .watch(subjectsProvider)
                            .map((e) => MyDropdownItem(e.name, e.id!))
                            .toList(),
                        value: _provider.subjectId,
                        prefixText: 'Subject',
                        emptyText: 'You have no subjects',
                        unselectedText: 'Select subject',
                        isSubject: true,
                        intCallback: (val) {
                          _provider.setsubjectId(val);
                          if (!changed) changed = true;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Tile(
                      margin: EdgeInsets.zero,
                      title: _provider.gradingSystem.name,
                      subtitle: 'Grading system',
                      dropdown: true,
                      color: null,
                      pressAction: SheetTileActionData<GradingSystem>(
                        actions: gradingSystem,
                        selectedAction: _gradingSystem,
                        valueChanged: (context, val) {
                          _provider.setGradingSystem(val);
                          setState(() => _gradingSystem = val);
                          if (!changed) changed = true;
                        },
                      ),
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
