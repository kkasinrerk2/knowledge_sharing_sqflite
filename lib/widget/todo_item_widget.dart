import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_sharing_sqlflite/controller/todo_controller.dart';
import 'package:knowledge_sharing_sqlflite/model/todo.dart';
import 'package:knowledge_sharing_sqlflite/widget/subtask_item_widget.dart';

class TodoItemWidget extends ConsumerStatefulWidget {
  final Todo todo;
  const TodoItemWidget({super.key, required this.todo});

  @override
  ConsumerState<TodoItemWidget> createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends ConsumerState<TodoItemWidget> {
  @override
  Widget build(BuildContext context) {
    final id = widget.todo.id;
    final editing = ref.watch(todoControllerProvider).editingSet.contains(id);
    if (editing) {
      return _EditTodoItem(
        todo: widget.todo,
        onSave: () {
          ref.read(todoControllerProvider.notifier).setEditing(id, false);
        },
      );
    }
    return _ViewTodoItem(
      todo: widget.todo,
      onTap: () {
        setState(() {
          ref.read(todoControllerProvider.notifier).setEditing(id, true);
        });
      },
    );
  }
}

class _EditTodoItem extends ConsumerStatefulWidget {
  final Todo todo;
  final void Function() onSave;
  const _EditTodoItem({required this.todo, required this.onSave});

  @override
  ConsumerState<_EditTodoItem> createState() => _EditTodoItemState();
}

class _EditTodoItemState extends ConsumerState<_EditTodoItem> {
  final TextEditingController _titleCtr = TextEditingController();
  final TextEditingController _descCtr = TextEditingController();
  final TextEditingController _newSubtaskCtr = TextEditingController();

  @override
  void initState() {
    _titleCtr.text = widget.todo.title;
    _descCtr.text = widget.todo.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: widget.todo.done,
        onChanged: (bool? value) {
          ref.read(todoControllerProvider.notifier).markDone(
            widget.todo, !widget.todo.done);
        },
      ),
      title: TextField(
        controller: _titleCtr,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _descCtr,
          ),
          const SizedBox(height: 20),
          _Subtasks(todo: widget.todo),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextField(
                  controller: _newSubtaskCtr,
                  decoration: InputDecoration(hintText: 'Add subtask'),
                ),
              ),
              IconButton(
                onPressed: () {
                  final text = _newSubtaskCtr.text;
                  if (text.isNotEmpty) {
                    ref.read(todoControllerProvider.notifier).newSubtask(
                      widget.todo.id, _newSubtaskCtr.text);
                  }
                },
                icon: Icon(
                  Icons.add,
                  color: _newSubtaskCtr.text.isNotEmpty ?
                    Colors.lightGreen : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () async {
              await ref.read(todoControllerProvider.notifier).update(
                  widget.todo.copyWith(
                    title: _titleCtr.text,
                    description: _descCtr.text,
                  )
              );
              widget.onSave();
            },
            icon: Icon(
              Icons.save,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              ref.read(todoControllerProvider.notifier).setEditing(
                  widget.todo.id, false);
            },
            icon: Icon(Icons.close, size: 30),
          ),
        ],
      ),
    );
  }
}

class _ViewTodoItem extends ConsumerWidget {
  final Todo todo;
  final void Function() onTap;
  const _ViewTodoItem({required this.todo, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: onTap,
      leading: Checkbox(
        value: todo.done,
        onChanged: (bool? value) {
          ref.read(todoControllerProvider.notifier).markDone(todo, !todo.done);
        },
      ),
      title: Text(todo.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(todo.description),
          const SizedBox(height: 20),
          if (todo.subtasks.isNotEmpty)
            _Subtasks(todo: todo),
        ],
      ),
      trailing: IconButton(
        onPressed: () {
          ref.read(todoControllerProvider.notifier).deleteTodo(todo.id);
        },
        icon: Icon(
          Icons.delete,
        )
      ),
    );
  }
}

class _Subtasks extends StatelessWidget {
  final Todo todo;
  const _Subtasks({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Subtasks: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        for (final subtask in todo.subtasks)
          SubtaskItemWidget(subtask: subtask),
      ],
    );
  }
}
