import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/src/common/network/provides_dio.dart';
import 'package:todo_app/src/todo/data/local/todo_local_data_source.dart';
import 'package:todo_app/src/todo/data/remote/todo_remote_data_source_impl.dart';
import 'package:todo_app/src/todo/data/todo_repository_impl.dart';
import 'package:todo_app/src/todo/domain/model/todo.dart';
import 'package:todo_app/src/todo/ui/model/todo_page_state.dart';
import 'package:todo_app/src/todo/ui/viewmodel/todo_view_model.dart';

class TodoLocalDataSourceMock extends TodoLocalDatasource {
  @override
  Future<String?> author() async {
    return "Amro";
  }
}

class AppLocalizationsMock extends Mock implements AppLocalizations {}

void main() {
  final localDataSource = TodoLocalDataSourceMock();
  if (Directory.current.path.endsWith('/test')) {
    Directory.current = Directory.current.parent;
  }
  MockWebServer server = MockWebServer();
  final localizations = AppLocalizationsMock();
  TodoViewModel viewModel = TodoViewModel();
  setUp(() async {
    await server.start();
    final remoteDataSource = TodoRemoteDataSourceImpl(providesDio(server.url));
    final repository = TodoRepositoryImpl(localDataSource, remoteDataSource);
    server.enqueue(
        body: [],
        httpCode: 200,
        headers: {"content-type": Headers.jsonContentType});
    viewModel = viewModel.inject(repository, localizations);
  });
  tearDown(() async {
    await server.shutdown();
  });

  test('ok get todo', () async {
    final expectedTodo = [
      Todo("Meeting 2", false, "description", 1700002800000, "Amro",
          "a06183cc-a8de-4adc-bbf2-5608eaa86a74"),
      Todo("Meeting", true, "description", 1668466800000, "Amro",
          "945e8408-3a47-4dd8-9549-dc0624b325de")
    ];
    final file = File('test/resources/ok_get_todo.json');
    server.enqueue(
        body: await file.readAsString(),
        httpCode: 200,
        headers: {"content-type": Headers.jsonContentType});
    await viewModel.fetchData();
    expect(viewModel.state, TodoPageState.success);
    expect(viewModel.todos.length, expectedTodo.length);
    final expectedMeeting2 = expectedTodo.first;
    final actualTodoMeeting2 =
        viewModel.todos.firstWhere((element) => element.title == "Meeting 2");
    expect(actualTodoMeeting2.id, expectedMeeting2.id);
    expect(actualTodoMeeting2.title, expectedMeeting2.title);
    expect(actualTodoMeeting2.description, expectedMeeting2.description);
    expect(actualTodoMeeting2.done, expectedMeeting2.done);
    expect(actualTodoMeeting2.dueDate, expectedMeeting2.dueDate);
    expect(actualTodoMeeting2.author, expectedMeeting2.author);

    expect(viewModel.todos.length, expectedTodo.length);
    final expectedMeeting1 = expectedTodo.last;
    final actualTodoMeeting1 =
        viewModel.todos.firstWhere((element) => element.title == "Meeting");
    expect(actualTodoMeeting1.id, expectedMeeting1.id);
    expect(actualTodoMeeting1.title, expectedMeeting1.title);
    expect(actualTodoMeeting1.description, expectedMeeting1.description);
    expect(actualTodoMeeting1.done, expectedMeeting1.done);
    expect(actualTodoMeeting1.dueDate, expectedMeeting1.dueDate);
    expect(actualTodoMeeting1.author, expectedMeeting1.author);
  });

  test('ko get todo', () async {
    final file = File('test/resources/ok_get_todo.json');
    server.enqueue(
        body: await file.readAsString(),
        httpCode: 400,
        headers: {"content-type": Headers.jsonContentType});
    await viewModel.fetchData();
    expect(viewModel.state, TodoPageState.success);
    expect(viewModel.todos, []);
  });

  test("on todo pressed", () {
    viewModel.onTodoPressed(Todo("Meeting 2", false, "description",
        1700002800000, "Amro", "a06183cc-a8de-4adc-bbf2-5608eaa86a74"));
    expect(
        viewModel.editTodoState.dueDate?.millisecondsSinceEpoch, 1700002800000);
    expect(viewModel.editTodoState.titleController.value.text, "Meeting 2");
    expect(viewModel.editTodoState.descriptionController.value.text,
        "description");
    expect(viewModel.editTodoState.isDone, false);
    expect(viewModel.editTodoState.id, "a06183cc-a8de-4adc-bbf2-5608eaa86a74");
  });

  test("on add pressed", () {
    viewModel.onTodoPressed(Todo("Meeting 2", false, "description",
        1700002800000, "Amro", "a06183cc-a8de-4adc-bbf2-5608eaa86a74"));
    expect(
        viewModel.editTodoState.dueDate?.millisecondsSinceEpoch, 1700002800000);
    expect(viewModel.editTodoState.titleController.value.text, "Meeting 2");
    expect(viewModel.editTodoState.descriptionController.value.text,
        "description");
    expect(viewModel.editTodoState.isDone, false);
    expect(viewModel.editTodoState.id, "a06183cc-a8de-4adc-bbf2-5608eaa86a74");
  });

  test('ok save todo', () async {
    final expectedTodo = [
      Todo("Meeting 2", false, "description", 1700002800000, "Amro",
          "a06183cc-a8de-4adc-bbf2-5608eaa86a74"),
      Todo("Meeting", true, "description", 1668466800000, "Amro",
          "945e8408-3a47-4dd8-9549-dc0624b325de")
    ];
    final file = File('test/resources/ok_get_todo.json');
    server.enqueue(
        body: await file.readAsString(),
        httpCode: 200,
        headers: {"content-type": Headers.jsonContentType});
    server.enqueue(
        body: await file.readAsString(),
        httpCode: 200,
        headers: {"content-type": Headers.jsonContentType});
    viewModel.onAddTodoPressed();
    viewModel.addTodoState.titleController.text = "Title";
    await viewModel.saveNewTodo();
    expect(viewModel.state, TodoPageState.success);
    expect(viewModel.todos.length, expectedTodo.length);
    final expectedMeeting2 = expectedTodo.first;
    final actualTodoMeeting2 =
        viewModel.todos.firstWhere((element) => element.title == "Meeting 2");
    expect(actualTodoMeeting2.id, expectedMeeting2.id);
    expect(actualTodoMeeting2.title, expectedMeeting2.title);
    expect(actualTodoMeeting2.description, expectedMeeting2.description);
    expect(actualTodoMeeting2.done, expectedMeeting2.done);
    expect(actualTodoMeeting2.dueDate, expectedMeeting2.dueDate);
    expect(actualTodoMeeting2.author, expectedMeeting2.author);

    expect(viewModel.todos.length, expectedTodo.length);
    final expectedMeeting1 = expectedTodo.last;
    final actualTodoMeeting1 =
        viewModel.todos.firstWhere((element) => element.title == "Meeting");
    expect(actualTodoMeeting1.id, expectedMeeting1.id);
    expect(actualTodoMeeting1.title, expectedMeeting1.title);
    expect(actualTodoMeeting1.description, expectedMeeting1.description);
    expect(actualTodoMeeting1.done, expectedMeeting1.done);
    expect(actualTodoMeeting1.dueDate, expectedMeeting1.dueDate);
    expect(actualTodoMeeting1.author, expectedMeeting1.author);
  });

  test('ko save todo 1', () async {
    final file = File('test/resources/ok_get_todo.json');
    server.enqueue(
        body: await file.readAsString(),
        httpCode: 400,
        headers: {"content-type": Headers.jsonContentType});
    server.enqueue(
        body: await file.readAsString(),
        httpCode: 400,
        headers: {"content-type": Headers.jsonContentType});
    viewModel.onAddTodoPressed();
    viewModel.addTodoState.titleController.text = "Title";
    await viewModel.saveNewTodo();
    expect(viewModel.state, TodoPageState.success);
    expect(viewModel.todos, []);
  });
}
