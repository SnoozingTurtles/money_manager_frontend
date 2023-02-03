import 'package:money_manager/domain/models/transaction_model.dart';

import '../value_objects/user/value_objects.dart';

abstract class ITransactionRepository{
  Future<void> add({required Transaction transaction,required UserId localId, UserId? remoteId});
  Future<List<Transaction>> getLocal({required String startDate,required String endDate,UserId? id});
  Future<List<Transaction>> getRemote({required String startDate,required String endDate,UserId? id});
  Future<List<Map<String,Object?>>> getBuffer();
  Future<void> syncRemoteToLocal({UserId? remoteId});
  Future<void> syncLocalToRemote({UserId? remoteId});

}