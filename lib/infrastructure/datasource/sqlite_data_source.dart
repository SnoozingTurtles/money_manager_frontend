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
    var listOfMapsExpenses = await getExpense();
    var listOfMapsIncome = await getIncome();
    var listOfMaps = [...listOfMapsIncome, ...listOfMapsExpenses];
    if (listOfMaps.isEmpty) return [];
    return listOfMaps;
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {

    await _db.insert('expense', expense.toMap());
  }

  @override
  Future<void> addIncome(IncomeModel income) async {
    await _db.insert('income', income.toMap());
  }

  Future<void> addBuffer(TransactionModel transaction) async{
    if(transaction is IncomeModel){
      await _db.insert('buffer',transaction.toBufferMap());
    }else if(transaction is ExpenseModel){
      await _db.insert('buffer', transaction.toBufferMap());
    }
  }

  Future<List<Map<String,Object?>>> getBuffer() async{
    var lOfMaps = await _db.query('buffer');
    if(lOfMaps.isEmpty) return [];

    return lOfMaps;
  }
  Future<void> clearBuffer()async{
    await _db.delete('buffer');
  }


  @override
  Future<List<ExpenseModel>> getExpense()async {
    var listOfMapsExpenses = await _db.query('expense');
  return listOfMapsExpenses.map<ExpenseModel>((map) => ExpenseModel.fromMap(map)).toList();
  }

  @override
  Future<List<IncomeModel>> getIncome()async {
    var listOfMapIncome = await _db.query('income');
    return listOfMapIncome.map<IncomeModel>((map) => IncomeModel.fromMap(map)).toList();
  }
}
