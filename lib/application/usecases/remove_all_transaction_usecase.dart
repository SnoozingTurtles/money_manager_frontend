import 'package:money_manager/infrastructure/repository/transaction_repository.dart';

class RemoveAllTransactionUseCase {
  final TransactionRepository _transactionRepository;

  RemoveAllTransactionUseCase({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository;
  Future<void> execute() async {
    await _transactionRepository.clearDB();
  }
}
