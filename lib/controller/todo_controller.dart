import 'package:knowledge_sharing_sqlflite/controller/todo_state.dart';
import 'package:knowledge_sharing_sqlflite/model/todo.dart';
import 'package:knowledge_sharing_sqlflite/service/local_todo_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'todo_controller.g.dart';

const uuid = Uuid();

@Riverpod(keepAlive: true)
class TodoController extends _$TodoController {
  LocalTodoService get _localTodoService => ref.read(localTodoServiceProvider);

  @override
  TodoState build() {
    return const TodoState();
  }

  Future<void> fetchTodo() async {
    try {
      if (state.status == TodoStatus.loading) {
        return;
      }
      state = state.copyWith(status: TodoStatus.loading);
      final todoList = await _localTodoService.fetchTodo();
      state = state.copyWith(
        todoList: todoList,
        status: TodoStatus.idle,
      );
    } catch (e) {
      state = state.copyWith(
        status: TodoStatus.idle,
      );
    }
  }

  Future<void> delete(String id) async {
    try {
      final todoList = await _localTodoService.deleteTodo(id);
      state = state.copyWith(
        todoList: todoList,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  Future<void> markDone(Todo todo, bool done) async {
    try {
      final todoList = await _localTodoService.markDone(todo.id, done);
      state = state.copyWith(
        todoList: todoList,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  Future<void> newTodo() async {
    try {
      final todoList = await _localTodoService.upsertTodo(Todo(
        id: uuid.v4(),
        updatedAt: DateTime.now(),
      ));
      state = state.copyWith(
        todoList: todoList,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  Future<void> update(Todo todo) async {
    try {
      final todoList = await _localTodoService.upsertTodo(todo);
      state = state.copyWith(
        todoList: todoList,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

}
