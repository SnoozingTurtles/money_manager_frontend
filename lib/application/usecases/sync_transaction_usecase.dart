import 'package:money_manager/application/boundaries/sync_all_transactions/ISyncAllTransactionUseCase.dart';
import 'package:money_manager/domain/value_objects/user/value_objects.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';

class SyncAllTransactionUseCase implements ISyncAllTransactionUseCase {
  TransactionRepository _transactionRepository;

  SyncAllTransactionUseCase({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository;
  @override
  Future<void> executeLocalToRemote({UserId? remoteId}) async {
    var transactions = await _transactionRepository.getBuffer();
    // print(transactions);
    if (transactions.isNotEmpty && remoteId != null) {
      await _transactionRepository.syncLocalToRemote(remoteId: remoteId);
    }
  }

  @override
  Future<void> executeRemoteToLocal({UserId? remoteId}) async {
    // print("execute remote to local");
    if(remoteId != null) {
      await _transactionRepository.syncRemoteToLocal(remoteId: remoteId);
    }
  }
}
