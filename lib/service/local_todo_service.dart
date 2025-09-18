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
    final db = await _db.future;
    final List<Map<String, Object?>> res = await db.rawQuery(
      '''
      SELECT 
        t.id,
        t.title,
        t.description,
        t.updated_at,
        t.done,
        s.id AS subtask_id,
        s.task
      FROM $_todoListTable t
      LEFT JOIN $_subtasksTable s ON s.todo_id = t.id
      ORDER BY done ASC, updated_at DESC
      '''
    );

    /// Map between todo.id and todo
    final Map<String, Todo> todos = {};
    for (final row in res) {
      final todoRow = Todo.fromJson(row);
      final subtask = Subtask.tryFromJson(row);
      if (!todos.keys.contains(todoRow.id)) {
        todos[todoRow.id] = todoRow;
      }
      if (subtask != null) {
        todos[todoRow.id] = todoRow.copyWith(
          subtasks: [...todos[todoRow.id]!.subtasks, subtask]
        );
      }
    }
    return todos.values.toList();
  }

  Future<List<Todo>> deleteTodo(String id) async {
    await (await _db.future).delete(_todoListTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    return fetchTodo();
  }

  Future<List<Todo>> insertSubtask(String todoId, Subtask subtask) async {
    await (await _db.future).insert(
      _subtasksTable,
      {
        'id': subtask.id,
        'todo_id': todoId,
        'task': subtask.task,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return fetchTodo();
  }

  Future<List<Todo>> deleteSubtask(String id) async {
    await (await _db.future).delete(_subtasksTable,  where: 'id = ?', whereArgs: [id]);
    return fetchTodo();
  }

  Future<List<Todo>> upsertTodo(Todo todo) async {
    await (await _db.future).insert(
      _todoListTable,
      {
        'id': todo.id,
        'title': todo.title,
        'description': todo.description,
        'done': todo.done ? 1 : 0,
        'updated_at': todo.updatedAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return fetchTodo();
  }

  Future<List<Todo>> markDone(String id, bool done) async {
    await (await _db.future).update(
      _todoListTable,
      {'done': done ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    return fetchTodo();
  }

}