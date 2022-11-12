import 'package:money_manager/infrastructure/datasource/IDatasource.dart';
import 'package:money_manager/infrastructure/model/model.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDataSource implements IDatasource {
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
  Future<List<TransactionModel>> get() async {
    var listOfMapsExpenses = await _db.query('expense');
    var listOfMapsIncome = await _db.query('income');
    var listOfMaps = [...listOfMapsIncome, ...listOfMapsExpenses];
    if (listOfMaps.isEmpty) return [];
    return listOfMaps.map<TransactionModel>((map) => ExpenseModel.fromMap(map)).toList();
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {

    await _db.insert('expense', expense.toMap());
  }

  @override
  Future<void> addIncome(IncomeModel income) async {
    await _db.insert('income', income.toMap());
  }
}
