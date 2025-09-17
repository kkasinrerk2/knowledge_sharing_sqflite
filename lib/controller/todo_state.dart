import 'package:equatable/equatable.dart';
import 'package:knowledge_sharing_sqlflite/model/todo.dart';

enum TodoStatus { init, idle, loading }

class TodoState extends Equatable {
  final TodoStatus status;
  final List<Todo> todoList;
  final String? error;

  const TodoState({
    this.status = TodoStatus.init,
    this.todoList = const [],
    this.error,
  });

  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? todoList,
    String? error,
  }) {
    return TodoState(
      status: status ?? this.status,
      todoList: todoList ?? this.todoList,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    todoList.hashCode,
    error,
  ];
}