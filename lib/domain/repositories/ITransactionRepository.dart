import 'package:money_manager/domain/models/transaction_model.dart';

abstract class ITransactionRepository{
  Future<void> add(Transaction transactions);
  //TODO: Update method
  Future<List<Transaction>> get();
}