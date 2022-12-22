abstract class ISyncAllTransactionUseCase{
  Future<void> executeLocalToRemote();
  Future<void> executeRemoteToLocal();
}