import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_sharing_sqlflite/model/subtask.dart';
import 'package:knowledge_sharing_sqlflite/model/todo.dart';
import 'package:sqflite/sqflite.dart';

final localTodoServiceProvider = Provider<LocalTodoService>((ref) {
  return LocalTodoService();
});

class LocalTodoService {
  static const _todoListTable = 'todolist';
  static const _subtasksTable = 'subtasks';
  final Completer<Database> _db = Completer<Database>();

  Future<void> initializeDatabase() async {
    final db = await openDatabase(
      '$_todoListTable.db',
      version: 2,
      onCreate: (db, version) async {
        await Future.wait([
          db.execute('''
            CREATE TABLE IF NOT EXISTS $_todoListTable (
              id String PRIMARY KEY,
              title text,
              description text,
              updated_at TIMESTAMP NOT NULL,
              done INTEGER
            )
          '''),
          db.execute('''
            CREATE TABLE IF NOT EXISTS $_subtasksTable (
              id TEXT PRIMARY KEY,
              task TEXT,
              todo_id TEXT,
              FOREIGN KEY (todo_id) REFERENCES $_todoListTable(id) ON DELETE CASCADE
            )
          '''),
        ]);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $_subtasksTable (
              id TEXT PRIMARY KEY,
              task TEXT,
              todo_id TEXT,
              FOREIGN KEY (todo_id) REFERENCES $_todoListTable(id) ON DELETE CASCADE
            )
          ''');
        }
      }
    );
    _db.complete(db);
  }

  Future<List<Todo>> fetchTodo() async {
    // TODO: implement this
    return [];
  }

  Future<List<Todo>> deleteTodo(String id) async {
    /// TODO: implement this
    return fetchTodo();
  }

  Future<List<Todo>> insertSubtask(String todoId, Subtask subtask) async {
    /// TODO: implement this
    return fetchTodo();
  }

  Future<List<Todo>> deleteSubtask(String id) async {
    /// TODO: implement this
    return fetchTodo();
  }

  Future<List<Todo>> upsertTodo(Todo todo) async {
    /// TODO: implement this
    return fetchTodo();
  }

  Future<List<Todo>> markDone(String id, bool done) async {
    /// TODO: implement this
    return fetchTodo();
  }

}