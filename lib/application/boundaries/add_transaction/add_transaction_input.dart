import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

abstract class AddTransactionInput {
  UserId id;
  Amount amount;
  Category category; //AddIncomeInput category
  Note? note;
  DateTime dateTime;
  bool recurring;

  AddTransactionInput(
      {required this.amount,
        required this.id,
        required this.category,
        this.note,
        required this.dateTime,
        required this.recurring});
}

class AddIncomeInput extends AddTransactionInput {
  AddIncomeInput(
      {required Amount amount,
        required UserId id,
        required Category category,
        Note? note,
        required DateTime dateTime,
        required bool recurring})
      : super(
      amount: amount,
      id:id,
      category: category,
      dateTime: dateTime,
      note: note,
      recurring: recurring);
}

class AddExpenseInput extends AddTransactionInput {
  String medium; //account, cash, card
  AddExpenseInput(
      {required Amount amount,
        required Category category,
        Note? note,
        required UserId id,
        required DateTime dateTime,
        required bool recurring,
        required this.medium})
      : super(
      amount: amount,
      id:id,
      category: category,
      dateTime: dateTime,
      note: note,
      recurring: recurring);

  @override
  String toString() {
    return "$amount";
  }
}
