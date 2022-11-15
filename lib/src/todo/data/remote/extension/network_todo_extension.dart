import 'package:todo_app/src/todo/data/remote/model/network_todo.dart';

import '../../../domain/model/todo.dart';

extension NetworkTdodExtension on NetworkTodo {
  Todo todo() {
    return Todo(title ?? "", done ?? false, description ?? '', dueDate,
        author ?? "", id ?? "");
  }
}
