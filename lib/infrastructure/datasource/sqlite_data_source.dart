import 'package:flutter/cupertino.dart';
import 'package:money_manager/infrastructure/datasource/i_data_source.dart';
import 'package:money_manager/infrastructure/datasource/i_user_data_source.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../../domain/models/transaction_model.dart';
import '../../domain/models/user_model.dart';
import '../../domain/value_objects/user/value_objects.dart';

class SqliteDataSource implements IDatasource, ILocalUserDataSource {
  final sql.Database _db;
  const SqliteDataSource({required sql.Database db}) : _db = db;
  @override
  Future<void> addTransaction({required Transaction model, UserId? remoteId}) async {
    // await _db.insert('transaction', model.toMap());
    if (model is Expense) {
      await addExpense(expense: model);
    } else if (model is Income) {
      await addIncome(income: model);
    }
  }

  @override
  Future<List<Transaction>> get({required String startDate, required String endDate, UserId? remoteId}) async {
    var listOfMapsExpenses = await getExpense(startDate: startDate, endDate: endDate);
    var listOfMapsIncome = await getIncome(startDate: startDate, endDate: endDate);
    var listOfMaps = [...listOfMapsIncome, ...listOfMapsExpenses];
    if (listOfMaps.isEmpty) return [];
    return listOfMaps;
  }

  @override
  Future<void> addExpense({required Expense expense, UserId? remoteId}) async {
    await _db.insert('expense', expense.toMap());
    double expenseAmount = expense.amount.value.fold((l) => 0, (r) => double.parse(r));
    User user = await getUser(expense.localId);
    await _db.update('user', {"balance": (user.balance - expenseAmount), 'expense': (user.expense + expenseAmount)},
        where: "userId = ?", whereArgs: [expense.localId.value]);
  }

  @override
  Future<void> addIncome({required Income income, UserId? remoteId}) async {
    await _db.insert('income', income.toMap());
    double incomeAmount = income.amount.value.fold((l) => 0, (r) => double.parse(r));
    User user = await getUser(income.localId);
    await _db.update('user', {"balance": (user.balance + incomeAmount), 'income': (user.income + incomeAmount)},
        where: "userId = ?", whereArgs: [income.localId.value]);
  }

  Future<void> addBuffer(Transaction transaction) async {
    debugPrint('ADDING TRANSACTION TO BUFFER: $transaction');
    if (transaction is Income) {
      await _db.insert('buffer', transaction.toBufferMap());
    } else if (transaction is Expense) {
      await _db.insert('buffer', transaction.toBufferMap());
    }
  }

  Future<List<Map<String, Object?>>> getBuffer() async {
    var lOfMaps = await _db.query('buffer');
    if (lOfMaps.isEmpty) return [];

    return lOfMaps;
  }

  Future<void> clearBuffer() async {
    await _db.delete('buffer');
  }

  @override
  Future<List<Expense>> getExpense({required String startDate, required String endDate, UserId? remoteId}) async {
    var listOfMapsExpenses =
        await _db.query('expense', where: 'dateTime between ? and ?', whereArgs: [startDate, endDate]);
    return listOfMapsExpenses.map<Expense>((map) => Expense.fromMap(map)).toList();
  }

  @override
  Future<List<Income>> getIncome({required String startDate, required String endDate, UserId? remoteId}) async {
    var listOfMapIncome = await _db.query('income', where: 'dateTime between ? and ?', whereArgs: [startDate, endDate]);
    return listOfMapIncome.map<Income>((map) => Income.fromMap(map)).toList();
  }

  @override
  Future<void> updateUserId({required UserId remoteId}) async {
    await _db.update('user', {'remoteId': remoteId.value}, where: 'userId=?', whereArgs: [1]);
  }

  @override
  Future<int> generateUser() async {
    try {
      int id = await _db.insert('user', {'name': 'User', 'balance': 0, 'expense': 0, 'income': 0, 'loggedIn': 'false'});
      return id;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<User> getUser(UserId id) async {
    final value = await _db.query('user', where: "userId = ?", whereArgs: [id.value]);
    return User(
      localId: UserId(value[0]['userId'] as int),
      remoteId: value[0]['remoteId'] != null ? UserId(value[0]['remoteId'] as int) : null,
      balance: double.parse("${value[0]['balance']}"),
      income: double.parse("${value[0]['income']}"),
      expense: double.parse("${value[0]['expense']}"),
      loggedIn: bool.fromEnvironment("${value[0]['loggedIn']}"),
    );
  }

  @override
  Future<void> cleanDB() async {
    await _db.execute("delete from income");
    await _db.execute("delete from expense");
  }
}
