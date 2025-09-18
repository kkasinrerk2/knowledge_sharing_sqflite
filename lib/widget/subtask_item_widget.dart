import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_sharing_sqlflite/controller/todo_controller.dart';
import 'package:knowledge_sharing_sqlflite/model/subtask.dart';

class SubtaskItemWidget extends ConsumerWidget {
  final Subtask subtask;

  const SubtaskItemWidget({
    super.key,
    required this.subtask,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            ref.read(todoControllerProvider.notifier).deleteSubtask(subtask.id);
          },
          icon: Icon(
            Icons.close,
          ),
        ),
        Text(subtask.task),
      ],
    );
  }
}
