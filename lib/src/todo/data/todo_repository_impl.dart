import 'package:todo_app/src/todo/data/local/todo_local_data_source.dart';
import 'package:todo_app/src/todo/data/remote/todo_remote_data_source.dart';
import 'package:todo_app/src/todo/domain/model/todo.dart';
import 'package:todo_app/src/todo/domain/todo_repository.dart';

class TodoRepositoryImpl extends TodoRepository {
  final TodoLocalDatasource _localDataSource;
  final TodoRemoteDataSource _remoteDataSource;

  TodoRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<List<Todo>> todos() async {
    final author = await _localDataSource.author();
    if (author != null && author.isNotEmpty) {
      return await _remoteDataSource.getTodos(author);
    } else {
      return [];
    }
  }

  @override
  Future<List<Todo>> save(
      String title, String? description, int? dueDate) async {
    final author = await _localDataSource.author();
    if (author != null && author.isNotEmpty) {
      await _remoteDataSource.saveTodo(author, title, description, dueDate);
      return await _remoteDataSource.getTodos(author);
    } else {
      return [];
    }
  }

  @override
  Future<List<Todo>> delete(String id) async {
    final author = await _localDataSource.author();
    if (author != null && author.isNotEmpty && id.isNotEmpty) {
      await _remoteDataSource.delete(id);
      return await _remoteDataSource.getTodos(author);
    } else {
      return [];
    }
  }

  @override
  Future<List<Todo>> update(String id, bool done, String title,
      String? description, int? dueDate) async {
    final author = await _localDataSource.author();
    if (author != null && author.isNotEmpty) {
      await _remoteDataSource.updateTodo(id, done, title, description, dueDate);
      return await _remoteDataSource.getTodos(author);
    } else {
      return [];
    }
  }
}
