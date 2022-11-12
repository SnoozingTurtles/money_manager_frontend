import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/repositories/ITransactionRepository.dart';
import 'package:money_manager/infrastructure/datasource/IDatasource.dart';
import 'package:money_manager/infrastructure/model/model.dart';

class TransactionRepository implements ITransactionRepository {
  IDatasource _datasource;
  TransactionRepository({required IDatasource datasource}) : _datasource = datasource;
  @override
  Future<void> add(Transaction transaction) async {
    TransactionModel model;
    if (transaction is Expense) {
      model = ExpenseModel(
          amount: transaction.amount,
          category: transaction.category,
          dateTime: transaction.dateTime,
          recurring: transaction.recurring,
          note:transaction.note,
          medium: transaction.medium);
    } else {
      model = IncomeModel(
        amount: transaction.amount,
        category: transaction.category,
        dateTime: transaction.dateTime,
        recurring: transaction.recurring,
      );
    }
    return await _datasource.addTransaction(model);
  }

  @override
  Future<List<Transaction>> get() async {
    var value = await _datasource.get();
    return value;
  }
}
