import 'package:money_manager/infrastructure/model/model.dart';

abstract class IDatasource{
  Future<void> addTransaction(TransactionModel model);
  Future<void> addExpense(ExpenseModel expense);
  Future<void> addIncome(IncomeModel income);
  Future<List<TransactionModel>> get(String startDate, String endDate);
  Future<List<IncomeModel>> getIncome(String startDate, String endDate);
  Future<List<ExpenseModel>> getExpense(String startDate, String endDate);
}