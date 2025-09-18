import 'package:equatable/equatable.dart';

class Subtask extends Equatable {
  final String id;
  final String task;

  const Subtask({
    required this.id,
    this.task = "New task",
  });

  Subtask copyWith({
    String? task,
  }) {
    return Subtask(
      id: id,
      task: task ?? this.task,
    );
  }

  static Subtask? tryFromJson(Map<String, Object?> json) {
    final String? id = json['subtask_id'] as String?;
    if (id == null) {
      return null;
    }
    return Subtask(
      id: id,
      task: json['task'] as String,
    );
  }

  @override
  List<Object?> get props => [
    id,
    task,
  ];
}