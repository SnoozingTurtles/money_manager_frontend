import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseFactory {
  Future<Database> createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'expense');
    debugPrint(dbPath);
    var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }
  void populateDb(Database db, int version) async {
    await _createUserTable(db);
    await _createExpenseTable(db);
    await _createIncomeTable(db);
    await _createBufferTable(db);
  }

  _createUserTable(Database db) async{
    await db.execute("""CREATE TABLE user(
    userId INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    balance NUMERIC,
    expense NUMERIC,
    income NUMERIC
    );""");
  }
  _createExpenseTable(Database db) async {
    await db
        .execute("""CREATE TABLE expense(
    amount TEXT ,
    category TEXT,
    note TEXT,
    dateTime TEXT,
    recurring TEXT,
    medium TEXT,
    userId INTEGER,
    FOREIGN KEY(userId) REFERENCES user(userId)
    );""")
        .then((_) => print('creating expense table....'))
        .catchError(
            (onError) => print('error creating expense table $onError'));


  }

  _createIncomeTable(Database db) async {
     await db
        .execute("""CREATE TABLE income(
    amount TEXT,
    category TEXT,
    note TEXT,
    dateTime TEXT,
    recurring TEXT,
    userId INTEGER,
    FOREIGN KEY(userId) REFERENCES user(userId)
    );""")
        .then((_) => print('creating income table....'))
        .catchError((onError) => print('error creating income table $onError'));
  }

  _createBufferTable(Database db)async{
    await db.execute("""CREATE TABLE buffer(
    amount TEXT PRIMARY KEY,
    category TEXT,
    note TEXT,
    dateTime TEXT,
    recurring TEXT,
    medium TEXT,
    transactionType TEXT,
    userId INTEGER,
    FOREIGN KEY(userId) REFERENCES user(userId)
    );""");
  }
  dropAllTables(Database db) async {
    await db.delete('expense');
    await db.delete('income');
  }

}
