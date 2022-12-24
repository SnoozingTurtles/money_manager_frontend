import 'package:money_manager/domain/value_objects/user/value_objects.dart';

abstract class ISyncAllTransactionUseCase{
  Future<void> executeLocalToRemote({UserId? remoteId});
  Future<void> executeRemoteToLocal({UserId? remoteId});
}