import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

import '../value_objects/user/value_objects.dart';

abstract class ITransactionRepository{
  Future<void> add(Transaction transactions,UserId id);
  Future<List<Transaction>> getLocal(String startDate, String endDate);
  Future<List<Transaction>> getRemote(String startDate, String endDate);
  Future<List<Map<String,Object?>>> getBuffer();
  Future<void> syncRemoteToLocal();
  Future<void> syncLocalToRemote();

}