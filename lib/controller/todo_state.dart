import 'package:equatable/equatable.dart';
import 'package:knowledge_sharing_sqlflite/model/todo.dart';

enum TodoStatus { init, idle, loading }

class TodoState extends Equatable {
  final TodoStatus status;
  final List<Todo> todoList;
  final Set<String> editingSet;
  final String? error;

  const TodoState({
    this.status = TodoStatus.init,
    this.todoList = const [],
    this.editingSet = const {},
    this.error,
  });

  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? todoList,
    Set<String>? editingSet,
    String? error,
  }) {
    return TodoState(
      status: status ?? this.status,
      todoList: todoList ?? this.todoList,
      editingSet: editingSet ?? this.editingSet,
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
