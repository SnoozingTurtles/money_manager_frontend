import 'package:money_manager/domain/models/transaction_model.dart';

abstract class ITransactionRepository{
  void add(List<Transaction> transactions);
  //TODO: Update method
  List<Transaction> get();
}