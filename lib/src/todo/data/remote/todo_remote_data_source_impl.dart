import 'package:dio/dio.dart';
import 'package:todo_app/src/todo/data/remote/extension/network_todo_extension.dart';
import 'package:todo_app/src/todo/data/remote/model/network_todo.dart';
import 'package:todo_app/src/todo/data/remote/todo_remote_data_source.dart';
import 'package:todo_app/src/todo/domain/model/todo.dart';

class TodoRemoteDataSourceImpl extends TodoRemoteDataSource {
  final Dio _client;

  TodoRemoteDataSourceImpl(this._client);

  @override
  Future<List<Todo>> getTodos(String author) async {
    try {
      final response = await _client
          .get<List<dynamic>>("todo", queryParameters: {"author": author});
      return response.data
              ?.map((e) => NetworkTodo.fromJson(e).todo())
              .toList() ??
          [];
    } catch (error) {
      return [];
    }
  }

  @override
  Future<void> saveTodo(
      String author, String title, String? description, int? dueDate) async {
    try {
      final response = await _client.post("todo", data: {
        "author": author,
        "title": title,
        "description": description,
        "dueDate": dueDate
      });
      response.data?.map((e) => NetworkTodo.fromJson(e).todo()).toList() ?? [];
    } catch (error) {
      return;
    }
    return;
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _client.delete("todo/$id");
    } catch (error) {
      return;
    }
    return;
  }

  @override
  Future<void> updateTodo(String id, bool done, String title,
      String? description, int? dueDate) async {
    try {
      final response = await _client.patch("todo", data: {
        "id": id,
        "title": title,
        "description": description ?? '',
        "dueDate": dueDate,
        "done": done
      });
      response.data?.map((e) => NetworkTodo.fromJson(e).todo()).toList() ?? [];
    } catch (error) {
      return;
    }
    return;
  }
}
