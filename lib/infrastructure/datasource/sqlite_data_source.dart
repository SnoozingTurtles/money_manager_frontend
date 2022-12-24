import 'package:flutter/cupertino.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';
import 'package:money_manager/infrastructure/datasource/i_data_source.dart';
import 'package:money_manager/infrastructure/datasource/i_user_data_source.dart';
import 'package:money_manager/infrastructure/model/infra_transaction_model.dart';
import 'package:money_manager/infrastructure/model/infra_user_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/value_objects/user/value_objects.dart';

class SqliteDataSource implements IDatasource, ILocalUserDataSource {
  final Database _db;
  const SqliteDataSource({required Database db}) : _db = db;
  @override
  Future<void> addTransaction(TransactionModel model) async {
    // await _db.insert('transaction', model.toMap());
    if (model is ExpenseModel) {
      await addExpense(model);
    } else if (model is IncomeModel) {
      await addIncome(model);
    }
  }

  @override
  Future<List<TransactionModel>> get(String startDate, String endDate) async {
    var listOfMapsExpenses = await getExpense(startDate, endDate);
    var listOfMapsIncome = await getIncome(startDate,endDate);
    var listOfMaps = [...listOfMapsIncome, ...listOfMapsExpenses];
    if (listOfMaps.isEmpty) return [];
    return listOfMaps;
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await _db.insert('expense', expense.toMap());
    double expenseAmount = expense.amount.value.fold((l) => 0, (r) => double.parse(r));
    UserModel user = await getUser(expense.id);
    await _db.update('user', {"balance": (user.balance - expenseAmount),'expense':(user.expense+expenseAmount)},
        where: "userId = ?", whereArgs: [expense.id.value]);
  }

  @override
  Future<void> addIncome(IncomeModel income) async {
    await _db.insert('income', income.toMap());
    double incomeAmount = income.amount.value.fold((l) => 0, (r) => double.parse(r));
    UserModel user = await getUser(income.id);
    await _db.update('user', {"balance": (user.balance + incomeAmount),'income':(user.income+incomeAmount)},
        where: "userId = ?", whereArgs: [income.id.value]);
  }

  Future<void> addBuffer(TransactionModel transaction) async {
    debugPrint('ADDING TRANSACTION TO BUFFER: $transaction');
    if (transaction is IncomeModel) {
      await _db.insert('buffer', transaction.toBufferMap());
    } else if (transaction is ExpenseModel) {
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
  Future<List<ExpenseModel>> getExpense(String startDate, String endDate) async {
    var listOfMapsExpenses = await _db.query('expense',where:'dateTime between ? and ?',whereArgs: [startDate,endDate]);
    print(listOfMapsExpenses);
    return listOfMapsExpenses.map<ExpenseModel>((map) => ExpenseModel.fromMap(map)).toList();
  }

  @override
  Future<List<IncomeModel>> getIncome(String startDate, String endDate) async {
    var listOfMapIncome = await _db.query('income',where:'dateTime between ? and ?',whereArgs: [startDate,endDate]);
    return listOfMapIncome.map<IncomeModel>((map) => IncomeModel.fromMap(map)).toList();
  }

  @override
  Future<int> addUser(UserModel user) {
    // TODO: implement addUser
    throw UnimplementedError();
  }

  @override
  Future<int> generateUser() async {
    try {
      int id = await _db.insert('user', {'name': 'User', 'balance': 0,'expense':0,'income':0,'loggedIn':'false'});
      print("Generated id  is $id");
      return id;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  @override
  Future<UserModel> getUser(UserId id) async {
    final value = await _db.query('user', where: "userId = ?", whereArgs: [id.value]);
    return UserModel(
      userId: UserId(value[0]['userId'] as int),
      balance: double.parse("${value[0]['balance']}"),
      income: double.parse("${value[0]['income']}"),
      expense: double.parse("${value[0]['expense']}"),
      loggedIn: bool.fromEnvironment("${value[0]['loggedIn']}"),
    );
  }

  @override
  Future<void> cleanDB()async {
    await _db.execute("delete from income");
    await _db.execute("delete from expense");
  }
}
