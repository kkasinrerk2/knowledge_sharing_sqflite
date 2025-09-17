import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_sharing_sqlflite/controller/todo_controller.dart';
import 'package:knowledge_sharing_sqlflite/model/todo.dart';

class TodoItemWidget extends ConsumerStatefulWidget {
  final Todo todo;
  const TodoItemWidget({super.key, required this.todo});

  @override
  ConsumerState<TodoItemWidget> createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends ConsumerState<TodoItemWidget> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return _EditTodoItem(
        todo: widget.todo,
        onSave: () {
          _editing = false;
        },
      );
    }
    return _ViewTodoItem(
      todo: widget.todo,
      onTap: () {
        setState(() {
          _editing = true;
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
      subtitle: TextField(
        controller: _descCtr,
      ),
      trailing: IconButton(
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
        )
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
      subtitle: Text(todo.description),
      trailing: IconButton(
        onPressed: () {
          ref.read(todoControllerProvider.notifier).delete(todo.id);
        },
        icon: Icon(
          Icons.delete,
        )
      ),
    );
  }
}
