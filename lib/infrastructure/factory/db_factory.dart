import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseFactory {
  Future<Database> createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'expense');
    print(dbPath);

    var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }

  void populateDb(Database db, int version) async {
    await _createExpenseTable(db);
    await _createIncomeTable(db);
  }

  _createExpenseTable(Database db) async {
    await db
        .execute("""CREATE TABLE expense(
    amount TEXT ,
    category TEXT,
    note TEXT,
    dateTime TEXT,
    recurring TEXT,
    medium TEXT
    );""")
        .then((_) => print('creating expense table....'))
        .catchError(
            (onError) => print('error creating expense table $onError'));
  }

  _createIncomeTable(Database db) async {
     await db
        .execute("""CREATE TABLE income(
    amount TEXT PRIMARY KEY,
    category TEXT,
    note TEXT,
    dateTime TEXT,
    recurring TEXT
    );""")
        .then((_) => print('creating income table....'))
        .catchError((onError) => print('error creating income table $onError'));
  }

  dropAllTables(Database db) async {
    await db.delete('expense');
    await db.delete('income');
  }
}
