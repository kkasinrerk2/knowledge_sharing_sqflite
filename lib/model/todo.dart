import 'package:equatable/equatable.dart';
import 'package:knowledge_sharing_sqlflite/model/subtask.dart';

class Todo extends Equatable {
  final String id;
  final bool done;
  final String title;
  final String description;
  final DateTime updatedAt;
  final List<Subtask> subtasks;

  const Todo({
    required this.id,
    this.done = false,
    this.title = "New TODO",
    this.description = '',
    required this.updatedAt,
    this.subtasks = const [],
  });

  Todo copyWith({
    bool? done,
    String? title,
    String? description,
    List<Subtask>? subtasks,
  }) {
    return Todo(
      id: id,
      done: done ?? this.done,
      title: title ?? this.title,
      description: description ?? this.description,
      updatedAt: DateTime.now(),
      subtasks: subtasks ?? this.subtasks,
    );
  }

  static Todo fromJson(Map<String, Object?> json) {
    return Todo(
      id: json['id'] as String,
      done: (json['done'] as int) != 0,
      title: json['title'] as String,
      description: json['description'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String)
    );
  }

  @override
  List<Object?> get props => [
    id,
    done,
    title,
    description,
    updatedAt,
    subtasks.hashCode,
  ];
}