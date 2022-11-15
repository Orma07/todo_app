import 'package:flutter/cupertino.dart';

class EditTodoStateModel {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  DateTime? dueDate;
  bool isDone = false;
  String id;
  final String? Function(String?) textValidator;

  EditTodoStateModel(this.id, this.textValidator);
}
