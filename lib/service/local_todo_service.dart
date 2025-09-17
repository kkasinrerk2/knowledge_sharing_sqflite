import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_sharing_sqlflite/model/todo.dart';
import 'package:sqflite/sqflite.dart';

final localTodoServiceProvider = Provider<LocalTodoService>((ref) {
  return LocalTodoService();
});

class LocalTodoService {
  static const _table = 'todolist';
  final Completer<Database> _db = Completer<Database>();

  Future<void> initializeDatabase() async {
    final db = await openDatabase(
      '$_table.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $_table (
            id String PRIMARY KEY,
            title text,
            description text,
            updated_at TIMESTAMP NOT NULL,
            done INTEGER
          )
        ''');
      },
    );
    _db.complete(db);
  }

  Future<List<Todo>> fetchTodo() async {
    final List<Map<String, Object?>> res = await (await _db.future).query(
      _table,
      orderBy: 'done ASC, updated_at DESC',
    );
    return res.map((map) => Todo.fromJson(map)).toList();
  }

  Future<List<Todo>> deleteTodo(String id) async {
    await (await _db.future).delete(_table,  where: 'id = ?', whereArgs: [id]);
    return fetchTodo();
  }

  Future<List<Todo>> upsertTodo(Todo todo) async {
    await (await _db.future).insert(
      _table,
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
      _table,
      {'done': done ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    return fetchTodo();
  }

}