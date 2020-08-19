import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/data_source/db_constant.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${TODOTable.tableName} (
            ${TODOTable.columnId} INTEGER PRIMARY KEY,
            ${TODOTable.columnTitle} TEXT NOT NULL,
            ${TODOTable.columnStartTime} TEXT NOT NULL,
            ${TODOTable.columnEndTime} TEXT NOT NULL,
            ${TODOTable.columnComplete} INTEGER DEFAULT 0
          )
          ''');
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryRow(
    String table,
    String where,
    List<int> args,
  ) async {
    Database db = await instance.database;
    return await db.query(table, where: where, whereArgs: args);
  }

  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(
    String table,
    Map<String, dynamic> row,
    String where,
    List<int> args,
  ) async {
    Database db = await instance.database;
    return await db.update(table, row, where: where, whereArgs: args);
  }

  Future<int> delete(
    String table,
    String where,
    List<int> args,
  ) async {
    Database db = await instance.database;
    return await db.delete(table, where: where, whereArgs: args);
  }
}
