// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkTodo _$NetworkTodoFromJson(Map<String, dynamic> json) => NetworkTodo(
      json['title'] as String?,
      json['done'] as bool?,
      json['description'] as String?,
      json['dueDate'] as int?,
      json['author'] as String?,
      json['id'] as String?,
    );

Map<String, dynamic> _$NetworkTodoToJson(NetworkTodo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'done': instance.done,
      'description': instance.description,
      'dueDate': instance.dueDate,
      'author': instance.author,
      'id': instance.id,
    };
