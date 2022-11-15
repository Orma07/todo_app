import 'package:flutter/cupertino.dart';

class AddTodoStateModel {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  DateTime? dueDate;
  final String? Function(String?) textValidator;

  AddTodoStateModel(this.textValidator);
}
