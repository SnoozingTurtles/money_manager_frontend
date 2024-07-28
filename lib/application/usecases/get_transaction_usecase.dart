import 'package:money_manager/application/boundaries/get_transactions/get_transaction_output.dart';
import 'package:money_manager/application/boundaries/get_transactions/i_get_all_transaction_usecase.dart';
import 'package:money_manager/application/boundaries/get_transactions/transaction_dto.dart';
import 'package:money_manager/domain/repositories/i_transaction_repository.dart';

import '../../domain/models/transaction_model.dart';

class GetAllTransactionUseCase implements IGetTransactionUseCase {
  final ITransactionRepository _transactionRepository;

  GetAllTransactionUseCase({required ITransactionRepository iTransactionRepository})
      : _transactionRepository = iTransactionRepository;

  @override
  Future<GetAllTransactionOutput> executeAllTime() async {
    String startDate = DateTime.now().subtract(const Duration(days: 360)).toIso8601String();
    String endDate = DateTime.now().add(const Duration(days: 360)).toIso8601String();

    return await _generateOutput(startDate, endDate);
  }

  @override
  Future<GetAllTransactionOutput> executeCustom(String startDate, String endDate) async {
    return await _generateOutput(startDate, endDate);
  }

  @override
  Future<GetAllTransactionOutput> executeLast3Months() async {
    String startDate = DateTime.now().subtract(const Duration(days: 90)).toIso8601String();
    String endDate = DateTime.now().toIso8601String();
    return await _generateOutput(startDate, endDate);
  }

  @override
  Future<GetAllTransactionOutput> executeLast6Months() async {
    String startDate = DateTime.now().subtract(const Duration(days: 180)).toIso8601String();
    String endDate = DateTime.now().toIso8601String();
    return await _generateOutput(startDate, endDate);
  }

  @override
  Future<GetAllTransactionOutput> executeLastMonth() async {
    String startDate = DateTime.now().subtract(const Duration(days: 60)).toIso8601String();
    String endDate = DateTime.now().subtract(const Duration(days: 30)).toIso8601String();

    return await _generateOutput(startDate, endDate);
  }

  @override
  Future<GetAllTransactionOutput> executeThisMonth() async {
    String startDate = DateTime.now().subtract(const Duration(days: 30)).toIso8601String();
    String endDate = DateTime.now().add(const Duration(days: 360)).toIso8601String();

    return await _generateOutput(startDate, endDate);
  }

  ///TEST FUNCTION
  Future<List<Transaction>> executeThisMonthTest() async {
    String startDate = DateTime.now().subtract(const Duration(days: 30)).toIso8601String();
    String endDate = DateTime.now().add(const Duration(days: 360)).toIso8601String();
    var transactions = await _transactionRepository.getLocal(startDate: startDate, endDate: endDate);

    return transactions;
  }

  Future<GetAllTransactionOutput> _generateOutput(String startDate, String endDate) async {
    var transactions = await _transactionRepository.getLocal(startDate: startDate, endDate: endDate);
    transactions.sort((t1, t2) {
      return t2.dateTime.compareTo(t1.dateTime);
    });
    var output = transactions
        .map((transaction) =>
            transaction is Expense ? ExpenseDTO.fromEntity(transaction) : IncomeDTO.fromEntity(transaction))
        .toList();

    // var test = transactions.groupBy((p0) => p0.dateTime.toString().substring(0,10));
    // var output =  test.map((key, value) => MapEntry(key, test[key]!.map((e) => e is Expense? ExpenseDTO.fromEntity(e):IncomeDTO.fromEntity(e),).toList()));

    return GetAllTransactionOutput(transactions: output);
  }
}
