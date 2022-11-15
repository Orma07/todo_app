import 'package:json_annotation/json_annotation.dart';

part 'network_todo.g.dart';

@JsonSerializable()
class NetworkTodo {
  final String? title;
  final bool? done;
  final String? description;
  final int? dueDate;
  final String? author;
  final String? id;

  factory NetworkTodo.fromJson(Map<String, dynamic> json) =>
      _$NetworkTodoFromJson(json);

  NetworkTodo(this.title, this.done, this.description, this.dueDate,
      this.author, this.id);

  Map<String, dynamic> toJson() => _$NetworkTodoToJson(this);
}
