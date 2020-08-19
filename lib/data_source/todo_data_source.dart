import 'package:todo/data_source/database_helper.dart';
import 'package:todo/data_source/db_constant.dart';
import 'package:todo/model/todo.dart';

abstract class TodoDataSource {
  Future<List<Todo>> getTodoList();
  Future<Todo> getTodo(int id);
  Future<Todo> createNewTodo(Todo todo);
  Future<Todo> updateTodo(int id, Todo todo);
}

class TodoLocalDataSource extends TodoDataSource {
  @override
  Future<List<Todo>> getTodoList() async {
    final allRows =
        await DatabaseHelper.instance.queryAllRows(TODOTable.tableName);

    List<Todo> todoItems = allRows.map((data) {
      return Todo(
        data[TODOTable.columnTitle],
        id: data[TODOTable.columnId],
        startDate: data[TODOTable.columnStartTime],
        endDate: data[TODOTable.columnEndTime],
        isFinish: data[TODOTable.columnComplete] == 1 ? true : false,
      );
    }).toList();

    return todoItems;
  }

  @override
  Future<Todo> createNewTodo(Todo todo) async {
    Map<String, dynamic> row = {
      TODOTable.columnTitle: todo.title,
      TODOTable.columnStartTime: todo.startDate,
      TODOTable.columnEndTime: todo.endDate,
    };
    int id = await DatabaseHelper.instance.insert(TODOTable.tableName, row);

    Todo newTodo = todo;
    newTodo.id = id;

    return newTodo;
  }

  @override
  Future<Todo> getTodo(int id) async {
    final rows = await DatabaseHelper.instance
        .queryRow(TODOTable.tableName, '${TODOTable.columnId} = ?', [id]);

    List<Todo> todoItems = rows.map((data) {
      return Todo.fromTableRow(data);
    }).toList();

    return todoItems.length > 0 ? todoItems.first : null;
  }

  @override
  Future<Todo> updateTodo(int todoID, Todo todo) async {
    var row = todo.toTableRow();
    int id = await DatabaseHelper.instance
        .update(TODOTable.tableName, row, '${TODOTable.columnId} = ?', [todoID]);
    return todo;
  }
}
