import 'package:money_manager/domain/models/transaction_model.dart';

abstract class ITransactionRepository{
  Future<void> add(Transaction transactions);
  Future<List<Transaction>> getLocal();
  Future<List<Transaction>> getRemote();
  Future<List<Map<String,Object?>>> getBuffer();
  Future<void> syncRemoteToLocal();
  Future<void> syncLocalToRemote();

}