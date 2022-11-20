import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

abstract class ITransactionRepository{
  Future<void> add(Transaction transactions,UserId id);
  Future<List<Transaction>> getLocal();
  Future<List<Transaction>> getRemote();
  Future<List<Map<String,Object?>>> getBuffer();
  Future<void> syncRemoteToLocal();
  Future<void> syncLocalToRemote();

}