import 'dart:collection';

import 'package:money_manager/application/boundaries/get_all_transactions/IGetAllTransactionUseCase.dart';
import 'package:money_manager/application/boundaries/get_all_transactions/get_all_transaction_output.dart';
import 'package:money_manager/application/boundaries/get_all_transactions/transaction_dto.dart';
import 'package:money_manager/domain/repositories/ITransactionRepository.dart';

class GetAllTransactionUseCase implements IGetAllTransactionUseCase {
  final ITransactionRepository _transactionRepository;

  GetAllTransactionUseCase(
      {required ITransactionRepository iTransactionRepository})
      : _transactionRepository = iTransactionRepository;

  @override
  Future<GetAllTransactionOutput> execute() async {
    var transactions = await _transactionRepository.getLocal();
    List<ExpenseDTO> output = transactions
        .map((transaction) => ExpenseDTO.fromEntity(transaction))
        .toList();
    return GetAllTransactionOutput(transactions: UnmodifiableListView(output));
  }
}
