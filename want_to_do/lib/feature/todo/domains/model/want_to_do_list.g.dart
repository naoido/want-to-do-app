// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'want_to_do_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      url: json['url'] as String?,
      createdAt: json['created_at'] as String,
      dueDate: json['due_date'] as String?,
      priority: json['priority'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      isCompleted: json['is_completed'] as bool,
    );

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'url': instance.url,
      'created_at': instance.createdAt,
      'due_date': instance.dueDate,
      'priority': instance.priority,
      'tags': instance.tags,
      'is_completed': instance.isCompleted,
    };

TodoList _$TodoListFromJson(Map<String, dynamic> json) => TodoList(
      todoList: (json['todo_list'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
      groupUserIds: (json['group_user_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TodoListToJson(TodoList instance) => <String, dynamic>{
      'todo_list': instance.todoList,
      'name': instance.name,
      'group_user_ids': instance.groupUserIds,
    };
