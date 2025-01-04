import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'want_to_do_list.g.dart';

@JsonSerializable()
class Todo {
  String id;
  final String title;
  final String content;
  final String? url;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'due_date')
  final String? dueDate;

  final String priority;
  final List<String> tags;

  @JsonKey(name: 'is_completed')
  bool isCompleted;

  Todo({
    String? id,
    required this.title,
    required this.content,
    this.url,
    required this.createdAt,
    this.dueDate,
    required this.priority,
    required this.tags,
    required this.isCompleted,
  }) : id = id ?? const Uuid().v4();

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);
}

@JsonSerializable()
class TodoList {
  @JsonKey(name: 'todo_list')
  final List<Todo> todoList;

  final String name;

  @JsonKey(name: 'group_user_ids')
  final List<String> groupUserIds;

  TodoList({
    required this.todoList,
    required this.name,
    required this.groupUserIds,
  });

  void add(Todo todo) {
    todoList.add(todo);
  }

  factory TodoList.fromJson(Map<String, dynamic> json) =>
      _$TodoListFromJson(json);
  Map<String, dynamic> toJson() => _$TodoListToJson(this);
}