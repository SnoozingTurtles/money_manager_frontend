import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/repositories/ITransactionRepository.dart';
import 'package:money_manager/infrastructure/model/model.dart';

List<Transaction> transactions = [ExpenseModel.fromMap(map),ExpenseModel.fromMap(map2)];
var map = {
  "amount": "200",
  "category": "food",
  "dateTime": DateTime.now().toIso8601String(),
  "note": "note",
  "recurring": "false",
  "medium": "cash",
};
var map2 = {
  "amount": "1000",
  "category": "clothes",
  "dateTime": DateTime.now().toIso8601String(),
  "note": "note",
  "recurring": "false",
  "medium": "cash",
};
class FakeTransactionRepository implements ITransactionRepository{


  @override
  Future<void> add(Transaction transaction) async{
     transactions.add(transaction);
  }

  @override
  Future<List<Transaction>> get() async{
    return transactions;
  }

}