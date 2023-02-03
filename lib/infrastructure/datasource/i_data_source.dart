
import 'package:money_manager/domain/models/transaction_model.dart';

import '../../domain/value_objects/user/value_objects.dart';
// import '../model/infra_transaction_model.dart';

abstract class IDatasource{
  Future<void> addTransaction({required Transaction model, UserId ?remoteId});
  Future<void> addExpense({required Expense expense, UserId ?remoteId});
  Future<void> addIncome({required Income income, UserId ?remoteId});
  Future<List<Transaction>> get({required String startDate,required String endDate, UserId? remoteId});
  Future<List<Income>> getIncome({required String startDate,required String endDate, UserId? remoteId});
  Future<List<Expense>> getExpense({required String startDate,required String endDate, UserId? remoteId});
}
