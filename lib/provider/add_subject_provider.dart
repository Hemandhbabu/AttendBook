import 'package:flutter/material.dart';

import '../database/dao/subject_dao.dart';
import '../database/entity/subject.dart';
import '../tile/tile_callback.dart';

class AddSubjectProvider {
  final int? id;
  String? _name;
  Color _color;
  String? _note;
  final Subject? loadedSubject;

  AddSubjectProvider(this.loadedSubject)
      : id = loadedSubject?.id,
        _name = loadedSubject?.name,
        _note = loadedSubject?.note,
        _color = loadedSubject?.color ?? Colors.blue;

  String? get name => _name;
  Color get color => _color;
  String? get note => _note;

  void setName(String name) {
    _name = name;
  }

  void setColor(Color color) {
    _color = color;
  }

  void setNote(String? note) {
    _note = note;
  }

  Future<Subject?> save({
    required BuildContext context,
    required int currentTerm,
    required SubjectDao dao,
    required void Function() pop,
  }) async {
    if (name == null) {
      MyTileCallback.showSnackbar(
        context: context,
        message: 'Fill all the required fields',
      );
      return null;
    }
    final subject = Subject(
      id: id,
      name: name!,
      colorValue: color.value,
      note: note,
      term: currentTerm,
    );
    if (loadedSubject == null) {
      final id = await dao.insertSubject(subject);
      MyTileCallback.showSnackbar(
        context: context,
        message: 'Subject added successfully',
      );
      pop();
      return subject.copyId(id);
    } else if (!loadedSubject!.isEqual(subject)) {
      await dao.updateSubject(subject);
      MyTileCallback.showSnackbar(
        context: context,
        message: 'Subject updated successfully',
      );
      pop();
      return subject;
    } else {
      MyTileCallback.showSnackbar(
        context: context,
        message: 'No changes found',
      );
      return null;
    }
  }
}
