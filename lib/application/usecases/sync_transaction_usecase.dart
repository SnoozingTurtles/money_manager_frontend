import 'package:money_manager/application/boundaries/sync_all_transactions/ISyncAllTransactionUseCase.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';

class SyncAllTransactionUseCase implements ISyncAllTransactionUseCase {
  TransactionRepository _transactionRepository;

  SyncAllTransactionUseCase({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository;
  @override
  Future<void> execute() async{
    var transactions = await _transactionRepository.getBuffer();
    print(transactions);
    if(transactions.isNotEmpty) {
      await _transactionRepository.syncLocalToRemote();
    }
  }
}