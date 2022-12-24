
import '../../domain/value_objects/user/value_objects.dart';
import '../model/infra_transaction_model.dart';

abstract class IDatasource{
  Future<void> addTransaction({required TransactionModel model, UserId ?remoteId});
  Future<void> addExpense({required ExpenseModel expense, UserId ?remoteId});
  Future<void> addIncome({required IncomeModel income, UserId ?remoteId});
  Future<List<TransactionModel>> get({required String startDate,required String endDate, UserId? remoteId});
  Future<List<IncomeModel>> getIncome({required String startDate,required String endDate, UserId? remoteId});
  Future<List<ExpenseModel>> getExpense({required String startDate,required String endDate, UserId? remoteId});
}
