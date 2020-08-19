import 'package:flutter/cupertino.dart';
import 'package:todo/data_source/db_constant.dart';

class Todo {
  int id;
  String title;
  bool isFinish;
  String startDate;
  String endDate;

  Todo(
    this.title, {
    this.id,
    @required this.startDate,
    @required this.endDate,
    this.isFinish = false,
  });

  Todo.fromTableRow(Map<String, dynamic> row) {
    title = row[TODOTable.columnTitle];
    id = row[TODOTable.columnId];
    startDate = row[TODOTable.columnStartTime];
    endDate = row[TODOTable.columnEndTime];
    isFinish = row[TODOTable.columnComplete] == 1 ? true : false;
  }

  toTableRow() {
    Map<String, dynamic> row = {
      TODOTable.columnId: id,
      TODOTable.columnTitle: title,
      TODOTable.columnStartTime: startDate,
      TODOTable.columnEndTime: endDate,
      TODOTable.columnComplete: isFinish ? 1 : 0,
    };

    return row;
  }
}
