import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domains/model/want_to_do_list.dart';
import '../domains/service/want_to_do_service.dart';
import 'create_todo_widget.dart';

class TodoListPage extends ConsumerStatefulWidget {
  const TodoListPage({super.key});

  @override
  ConsumerState<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends ConsumerState<TodoListPage> {
  final TodoListService _service = TodoListService.instance;

  List<Todo> _todos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initAll();
  }

  Future<void> _initAll() async {
    setState(() => _isLoading = true);
    try {
      await _service.init(ref);
      setState(() {
        _todos = _service.todoList.todoList;
      });
    } catch (e) {
      print('Failed to load: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createTodo(Todo todo) async {
    setState(() => _isLoading = true);
    try {
      await _service.addTodo(ref, todo);
      setState(() {
        _todos = _service.todoList.todoList;
      });
    } catch (e) {
      print('Failed to create todo: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleTodo(Todo todo) async {
    setState(() => _isLoading = true);
    try {
      await _service.toggleTodo(ref, todo.id);
      setState(() {
        _todos = _service.todoList.todoList;
      });
    } catch (e) {
      debugPrint('Failed to toggle: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showCreateTodoDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: CreateTodoForm(_createTodo),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _todos.isEmpty ? "" :
          '達成率: ${(_todos.where((todo) => todo.isCompleted).length / _todos.length * 100).toStringAsFixed(1)}%\n' +
          '達成: ${_todos.where((todo) => todo.isCompleted).length}/${_todos.length}',
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (_) => _toggleTodo(todo),
                  ),
                  title: Text(todo.title),
                  subtitle: Text('Priority: ${todo.priority}'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTodoDialog,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}