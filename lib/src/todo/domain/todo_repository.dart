import 'model/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> todos();

  Future<List<Todo>> save(String title, String? description, int? dueDate);

  Future<List<Todo>> delete(String id);

  Future<List<Todo>> update(
      String id, bool done, String title, String? description, int? dueDate);
}
