import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

abstract class AddTransactionOutput {
  Amount amount;
  Category category; //AddIncomeOutput category
  Note? note;
  DateTime dateTime;
  bool recurring;

  AddTransactionOutput(
      {required this.amount,
        required this.category,
        this.note,
        required this.dateTime,
        required this.recurring});
}

class AddIncomeOutput extends AddTransactionOutput {
  AddIncomeOutput(
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

class AddExpenseOutput extends AddTransactionOutput {
  String medium; //account, cash, card
  AddExpenseOutput(
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

  @override
  String toString() {
    return "$amount";
  }
}
