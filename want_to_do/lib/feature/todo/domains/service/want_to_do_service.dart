import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../provider/secure_storage_provider.dart';
import '../model/want_to_do_list.dart';

class TodoListService {
  static final TodoListService instance = TodoListService();
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://want-to-do-app.sbnaoido.workers.dev/api',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
  late TodoList _todoList;

  TodoList get todoList => _todoList;

  Future<void> init(WidgetRef ref) async {
    final storage = ref.read(secureStorageControllerProvider.notifier);

    _todoList = await fetchTodoList();
  }

  Future<TodoList> fetchTodoList() async {
    try {
      final response = await _dio.get('/items');
      if (response.statusCode == 200) {
        return TodoList.fromJson(jsonDecode(response.data));
      } else {
        throw Exception('Failed to fetch TodoList');
      }
    } catch (e) {
      throw Exception('Error fetching TodoList: $e');
    }
  }

  Future<void> addTodo(WidgetRef ref, Todo todo) async {
    _todoList.add(todo);
    await _saveNew(ref, todo);
  }

  Future<void> toggleTodo(WidgetRef ref, String todoId) async {
    Todo? changedItem;
    for (int i = 0; i < _todoList.todoList.length; i++) {
      if (_todoList.todoList[i].id == todoId) {
        changedItem = _todoList.todoList[i];
        _todoList.todoList[i].isCompleted = !_todoList.todoList[i].isCompleted;
        break;
      }
    }
    final storage = ref.read(secureStorageControllerProvider.notifier);
    if (changedItem == null) return;
    final jsonString = changedItem.toJson();
    try {
      final response = await _dio.patch(
        '/items',
        data: jsonString,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Todo update successfully');
      } else {
        throw Exception('Failed to create Todo');
      }
    } catch (e) {
      throw Exception('Error creating Todo: $e');
    }
    await storage.setValue(key: 'todo_list', value: jsonEncode(jsonString));
  }

  Future<void> _saveNew(WidgetRef ref, Todo todo) async {
    final storage = ref.read(secureStorageControllerProvider.notifier);
    todo.id = "";
    final jsonString = todo.toJson();
    try {
      final response = await _dio.post(
        '/items',
        data: jsonString,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Todo created successfully');
      } else {
        throw Exception('Failed to create Todo');
      }
    } catch (e) {
      throw Exception('Error creating Todo: $e');
    }
    await storage.setValue(key: 'todo_list', value: jsonEncode(jsonString));
  }
}
