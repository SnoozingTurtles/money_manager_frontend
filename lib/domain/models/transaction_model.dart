import 'package:equatable/equatable.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

abstract class Transaction extends Equatable {
  Amount amount;
  Category category; //Income category
  Note? note;
  DateTime dateTime;
  bool recurring;
  String? token;

  Transaction(
      {required this.amount,
      required this.category,
      this.note,
      this.token,
      required this.dateTime,
      required this.recurring});
}

class Income extends Transaction {
  Income(
      {required Amount amount,
      required Category category,
      Note? note,
      String? token,
      required DateTime dateTime,
      required bool recurring})
      : super(amount: amount, category: category, token: token, dateTime: dateTime, note: note, recurring: recurring);

  @override
  // TODO: implement props
  List<Object?> get props => [amount, category, note, dateTime, recurring];
}

class Expense extends Transaction {
  String medium; //account, cash, card
  Expense(
      {required Amount amount,
      required Category category,
      Note? note,
      String? token,
      required DateTime dateTime,
      required bool recurring,
      required this.medium})
      : super(amount: amount, category: category, token: token, dateTime: dateTime, note: note, recurring: recurring);

  @override
  String toString() {
    return "$amount";
  }

  @override
  // TODO: implement props
  List<Object?> get props => [amount, category, note, dateTime, recurring, medium];
}
