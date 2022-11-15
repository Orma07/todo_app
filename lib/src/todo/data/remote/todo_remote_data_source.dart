import '../../domain/model/todo.dart';

abstract class TodoRemoteDataSource {
  Future<List<Todo>> getTodos(String author);

  Future<void> saveTodo(
      String author, String title, String? description, int? dueDate);

  Future<void> delete(String id);

  Future<void> updateTodo(
      String id, bool done, String title, String? description, int? dueDate);
}
