import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_sharing_sqlflite/controller/todo_controller.dart';
import 'package:knowledge_sharing_sqlflite/widget/todo_item_widget.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sqlflite sample'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(todoControllerProvider.notifier).newTodo();
            },
            icon: Icon(Icons.add)
          ),
        ],
      ),
      body: const _TodoScreen(),
    );
  }
}


class _TodoScreen extends ConsumerStatefulWidget {
  const _TodoScreen();

  @override
  ConsumerState<_TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<_TodoScreen> {
  @override
  void initState() {
    Future(() {
      ref.read(todoControllerProvider.notifier).fetchTodo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(todoControllerProvider);
    if (state.todoList.isEmpty) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(todoControllerProvider.notifier).newTodo();
          },
          child: Text('Add new todo')
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(todoControllerProvider.notifier).fetchTodo();
      },
      child: ListView.separated(
        itemCount: state.todoList.length,
        itemBuilder: (context, index) {
          final item = state.todoList[index];
          return TodoItemWidget(
            key: ValueKey(item),
            todo: item,
          );
        },
        separatorBuilder: (_, __) {
          return const Divider();
        },
      ),
    );
  }

}
