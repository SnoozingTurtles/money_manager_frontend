import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

abstract class TransactionModel extends Transaction {
  Amount amount;
  Category category; //IncomeModel category
  Note? note;
  DateTime dateTime;
  bool recurring;

  TransactionModel(
      {required this.amount,
      required this.category,
      this.note,
      required this.dateTime,
      required this.recurring})
      : super(
            amount: amount,
            category: category,
            dateTime: dateTime,
            recurring: recurring,
            note: note);
}

class IncomeModel extends TransactionModel {
  IncomeModel(
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

  factory IncomeModel.fromMap(Map<String, dynamic> map) {
    return IncomeModel(
        amount: Amount(map["amount"]),
        category: Category(map["category"]),
        dateTime: DateTime.parse(map['dateTime']),
        recurring: bool.fromEnvironment(map['recurring']),
        note: Note(map['note']));
  }

  Map<String, dynamic> toMap() {
    return {
      "amount": amount.value.fold((l) => null, (r) => r),
      "category": category.value.fold((l) => null, (r) => r),
      "dateTime": dateTime.toIso8601String(),
      "recurring": recurring.toString(),
      "note": note != null ? note!.value.fold((l) => null, (r) => r) : null,
    };
  }
}

class ExpenseModel extends TransactionModel {
  String medium; //account, cash, card
  ExpenseModel(
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

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
        medium: map["medium"],
        amount: Amount(map["amount"]),
        category: Category(map["category"]),
        dateTime: DateTime.parse(map['dateTime']),
        recurring: bool.fromEnvironment(map['recurring']),
        note: Note(map['note']));
  }

  Map<String, dynamic> toMap() {
    return {
      "amount": amount.value.fold((l) => null, (r) => r),
      "category": category.value.fold((l) => null, (r) => r),
      "dateTime": dateTime.toIso8601String(),
      "recurring": recurring.toString(),
      "note": note != null ? note!.value.fold((l) => null, (r) => r) : null,
      "medium": medium.toString(),
    };
  }
}
