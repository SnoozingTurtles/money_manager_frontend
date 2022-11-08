import 'package:money_manager/domain/models/transaction_model.dart';

List<Transaction> transactions = [];
class ModelRepository{

  Future<List<Transaction>> getTransactions() async{
    await Future.delayed(const Duration(seconds: 1));
    return transactions;
  }
   addTransaction(Transaction transaction)async{
    // await Future.delayed(const Duration(seconds: 1));
    transactions.add(transaction);
  }
}