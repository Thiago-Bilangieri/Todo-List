import 'package:todo_list/app/core/database/sqlite_connection_factory.dart';
import 'package:todo_list/app/models/task_model.dart';

import './tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  final SqliteConnectionFactory _sqliteConnectionFactory;
  TasksRepositoryImpl(
      {required SqliteConnectionFactory sqliteConnectionFactory})
      : _sqliteConnectionFactory = sqliteConnectionFactory;
  @override
  Future<void> save(DateTime date, String description) async {
    final conn = await _sqliteConnectionFactory.openConnection();
    // await conn.rawInsert(sql);
    await conn.insert("todo", {
      "id": null,
      "description": description,
      "data_hora": date.toIso8601String(),
      "finished": 0
    });
  }

  @override
  Future<List<TaskModel>> findByPeriod(DateTime start, DateTime end) async {
    final startFilter = DateTime(start.year, start.month, start.day, 0, 0, 0);
    final endFilter = DateTime(end.year, end.month, end.day, 23, 59, 59);
    final conn = await _sqliteConnectionFactory.openConnection();
    final result = await conn.rawQuery(
      """select * 
        from todo 
        where data_hora between ? and ? 
        order by data_hora""",
      [
        startFilter.toIso8601String(),
        endFilter.toIso8601String(),
      ],
    );
    return result.map((e) => TaskModel.loadFromDb(e)).toList();
  }

  @override
  Future<void> checkOrUncheckTask(TaskModel taks) async {
    final conn = await _sqliteConnectionFactory.openConnection();
    await conn.update("todo", {"finished": taks.finished ? 1 : 0},
        where: "id = ?", whereArgs: [taks.id]);

    // await conn.rawUpdate("update todo set finished = ? where id =?",
    //     [taks.finished ? 1 : 0, taks.id]);
  }

  @override
  Future<void> delete(TaskModel task) async {
    final conn = await _sqliteConnectionFactory.openConnection();
    await conn.delete("todo", where: "id = ?", whereArgs: [task.id]);
  }

  Future<void> deleteAll() async {
    final conn = await _sqliteConnectionFactory.openConnection();
    conn.rawQuery("delete from todo");
  }
}
