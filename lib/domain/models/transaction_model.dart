import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

abstract class Transaction {
  Amount amount;
  Category category; //Income category
  Note? note;
  DateTime dateTime;
  bool recurring;

  Transaction(
      {required this.amount,
      required this.category,
      this.note,
      required this.dateTime,
      required this.recurring});
}

class Income extends Transaction {
  Income(
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

class Expense extends Transaction {
  String medium; //account, cash, card
  Expense(
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
