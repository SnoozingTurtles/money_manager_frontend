import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

abstract class TransactionDTO {
  Amount amount;
  Category category; //IncomeDTO category
  Note? note;
  DateTime dateTime;
  bool recurring;

  TransactionDTO(
      {required this.amount,
        required this.category,
        this.note,
        required this.dateTime,
        required this.recurring});
}

class IncomeDTO extends TransactionDTO {
  IncomeDTO(
      {required Amount amount,
        required Category category,
        Note? note,
        required DateTime dateTime,
        required bool recurring})
      : super(
      amount: amount,
      category: category,
      dateTime: dateTime,
      note: note,
      recurring: recurring);
}

class ExpenseDTO extends TransactionDTO {
  String medium; //account, cash, card
  ExpenseDTO(
      {required Amount amount,
        required Category category,
        Note? note,
        required DateTime dateTime,
        required bool recurring,
        required this.medium})
      : super(
      amount: amount,
      category: category,
      dateTime: dateTime,
      note: note,
      recurring: recurring);

  ExpenseDTO.fromEntity(Transaction transaction)
      : this(
      amount: transaction.amount,
      category: transaction.category,
      dateTime: transaction.dateTime,
      recurring: transaction.recurring,
      medium: "Cash",
      note: transaction.note);

  @override
  String toString() {
    return "$amount";
  }
}
