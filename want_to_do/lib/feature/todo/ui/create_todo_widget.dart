import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../domains/model/want_to_do_list.dart';
import '../domains/service/want_to_do_service.dart';

class CreateTodoForm extends ConsumerStatefulWidget {
  final Function(Todo) onSubmit;
  const CreateTodoForm(this.onSubmit, {super.key});

  @override
  ConsumerState<CreateTodoForm> createState() => _CreateTodoFormState();
}

class _CreateTodoFormState extends ConsumerState<CreateTodoForm> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _urlController = TextEditingController();
  final _dueDateController = TextEditingController();
  final TodoListService _service = TodoListService();

  String _selectedPriority = 'low';

  final List<String> _allTags = ['旅行', '仕事', '勉強', '趣味', '買い物'];
  final Set<String> _selectedTags = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title (必須)',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: 'Content (必須)',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'URL (任意)',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _dueDateController,
            decoration: const InputDecoration(
              labelText: 'Due Date (任意)',
              hintText: 'yyyy-MM-dd',
            ),
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  final format = DateFormat('yyyy-MM-dd');
                  _dueDateController.text = format.format(picked);
                });
              }
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text('Priority: '),
              const SizedBox(width: 8),
              ToggleButtons(
                isSelected: [
                  _selectedPriority == 'low',
                  _selectedPriority == 'mid',
                  _selectedPriority == 'high',
                ],
                onPressed: (index) {
                  setState(() {
                    if (index == 0) {
                      _selectedPriority = 'low';
                    } else if (index == 1) {
                      _selectedPriority = 'mid';
                    } else {
                      _selectedPriority = 'high';
                    }
                  });
                },
                children: const [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('low')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('mid')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('high')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // tags セクション (selector)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tags (複数選択可)',
            ),
          ),
          Wrap(
            spacing: 8,
            children: _allTags.map((tag) {
              final selected = _selectedTags.contains(tag);
              return ChoiceChip(
                label: Text(tag),
                selected: selected,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _onCreatePressed,
            child: const Text('Todoを作成'),
          ),
        ],
      ),
    );
  }

  void _onCreatePressed() {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title と Content は必須です')),
      );
      return;
    }

    final todo = Todo(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      url: _urlController.text.trim().isEmpty ? null : _urlController.text.trim(),
      createdAt: DateTime.now().toIso8601String(),
      dueDate: _dueDateController.text.trim().isEmpty
          ? null
          : _dueDateController.text.trim(),
      priority: _selectedPriority,
      tags: _selectedTags.toList(),
      isCompleted: false,
    );

    widget.onSubmit(todo);
    context.pop();
  }
}
