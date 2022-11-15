import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/src/todo/domain/todo_repository.dart';
import 'package:todo_app/src/todo/ui/model/add_todo_state.dart';

import '../../domain/model/todo.dart';
import '../model/edit_todo_state.dart';
import '../model/todo_page_state.dart';

class TodoViewModel extends ChangeNotifier {
  late TodoRepository _repository;
  late AppLocalizations _localization;
  TodoPageState state = TodoPageState.loading;
  List<Todo> todos = [];

  late AddTodoStateModel _addTodoStateModel;

  AddTodoStateModel get addTodoState => _addTodoStateModel;

  late EditTodoStateModel _editTodoStateModel;

  EditTodoStateModel get editTodoState => _editTodoStateModel;

  TodoViewModel inject(
      TodoRepository repository, AppLocalizations localization) {
    _repository = repository;
    _localization = localization;
    fetchData();
    return this;
  }

  Future<void> fetchData() async {
    todos = await _repository.todos();
    state = TodoPageState.success;
    notifyListeners();
  }

  void onAddTodoPressed() {
    _addTodoStateModel = AddTodoStateModel((p0) {
      if (p0?.isNotEmpty == true) {
        return null;
      } else {
        return _localization.invalidTitle;
      }
    });
  }

  void onTodoPressed(Todo todo) {
    _editTodoStateModel = EditTodoStateModel(todo.id, (p0) {
      if (p0?.isNotEmpty == true) {
        return null;
      } else {
        return _localization.invalidTitle;
      }
    });
    _editTodoStateModel.titleController.text = todo.title;
    _editTodoStateModel.descriptionController.text = todo.description;
    _editTodoStateModel.dateController.text = formatDate(todo.dueDate);
    _editTodoStateModel.isDone = todo.done;
    _editTodoStateModel.dueDate = todo.dueDate != null
        ? DateTime.fromMillisecondsSinceEpoch(todo.dueDate!)
        : null;
  }

  Future<void> saveNewTodo() async {
    state = TodoPageState.loading;
    notifyListeners();
    todos = await _repository.save(
        _addTodoStateModel.titleController.value.text,
        _addTodoStateModel.descriptionController.value.text,
        _addTodoStateModel.dueDate?.millisecondsSinceEpoch);
    state = TodoPageState.success;
    notifyListeners();
  }

  Future<void> updateTodo() async {
    state = TodoPageState.loading;
    notifyListeners();
    todos = await _repository.update(
        _editTodoStateModel.id,
        _editTodoStateModel.isDone,
        _editTodoStateModel.titleController.value.text,
        _editTodoStateModel.descriptionController.value.text,
        _editTodoStateModel.dueDate?.millisecondsSinceEpoch);
    state = TodoPageState.success;
    notifyListeners();
  }

  void onAddTodoDateChanged(DateTime? date) async {
    _addTodoStateModel.dueDate = date;
    _addTodoStateModel.dateController.text = _formatDate(date);
  }

  void onEditTodoDateChanged(DateTime? date) async {
    _editTodoStateModel.dueDate = date;
    _editTodoStateModel.dateController.text = _formatDate(date);
  }

  void deleteTodo() async {
    state = TodoPageState.loading;
    notifyListeners();
    todos = await _repository.delete(_editTodoStateModel.id);
    state = TodoPageState.success;
    notifyListeners();
  }

  String _formatDate(DateTime? dateTime) =>
      dateTime != null ? DateFormat('dd/MMMM/yyyy').format(dateTime) : '';

  String formatDate(int? dateInMilliseconds) {
    if (dateInMilliseconds != null && dateInMilliseconds > 0) {
      final date = DateTime.fromMillisecondsSinceEpoch(dateInMilliseconds);
      return _formatDate(date);
    } else {
      return '';
    }
  }

  void onIsDoneChanged() {
    _editTodoStateModel.isDone = !_editTodoStateModel.isDone;
    notifyListeners();
  }
}
