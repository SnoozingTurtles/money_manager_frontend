import 'package:equatable/equatable.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

import '../value_objects/user/value_objects.dart';

abstract class Transaction extends Equatable {
  final UserId localId;
  final Amount amount;
  final Category category; //Income category
  final Note? note;
  final DateTime dateTime;
  final bool recurring;
  final String? token;

  Transaction(
      {required this.localId,
      required this.amount,
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
      required UserId localId,
      Note? note,
      required DateTime dateTime,
      required bool recurring})
      : super(
            localId: localId, amount: amount, category: category, dateTime: dateTime, note: note, recurring: recurring);

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
        amount: Amount(map["amount"]),
        localId: UserId(map["userId"]),
        category: Category(map["category"]),
        dateTime: DateTime.parse(map['dateTime']),
        recurring: bool.fromEnvironment(map['recurring']),
        note: map['note'] == null ? null : Note(map['note']));
  }
  factory Income.fromSpringMap(Map<String, dynamic> map) {
    return Income(
        localId: UserId(1),
        amount: Amount("${map["amount"]}"),
        category: Category("${map["category"]}"),
        dateTime: DateTime.parse("${map['dateAdded']}"),
        recurring: bool.fromEnvironment("false"),
        note: map['description'] == null ? null : Note(map['description']!));
  }

  Income toDIncome() {
    return Income(
      localId: localId,
      amount: amount,
      dateTime: dateTime,
      category: category,
      recurring: recurring,
      note: note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": localId.value,
      "amount": amount.value.fold((l) => null, (r) => r),
      "category": category.value.fold((l) => null, (r) => r),
      "dateTime": dateTime.toIso8601String(),
      "recurring": recurring.toString(),
      "note": note != null ? note!.value.fold((l) => null, (r) => r) : null,
    };
  }

  Map<String, dynamic> toSpringMap() {
    return {
      "amount": amount.value.fold((l) => null, (r) => r),
      "type": category.value.fold((l) => null, (r) => r),
      "dateAdded": dateTime.toIso8601String(),
      // "recurring": recurring.toString(),
      "description": note != null ? note!.value.fold((l) => null, (r) => r) : null,
    };
  }

  Map<String, dynamic> toBufferMap() {
    return {
      "userId": localId.value,
      "amount": amount.value.fold((l) => null, (r) => r),
      "category": category.value.fold((l) => null, (r) => r),
      "dateTime": dateTime.toIso8601String(),
      "recurring": recurring.toString(),
      "note": note != null ? note!.value.fold((l) => null, (r) => r) : null,
      "transactionType": "income",
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [amount, category, note, dateTime, recurring];
}

class Expense extends Transaction {
  final String medium; //account, cash, card
  Expense(
      {required Amount amount,
      required UserId localId,
      required Category category,
      Note? note,
      required DateTime dateTime,
      required bool recurring,
      required this.medium})
      : super(
            localId: localId, amount: amount, category: category, dateTime: dateTime, note: note, recurring: recurring);

  @override
  String toString() {
    return "$amount";
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
        localId: UserId(map["userId"]),
        medium: map["medium"] ?? "Cash",
        amount: Amount(map["amount"]),
        category: Category(map["category"]),
        dateTime: DateTime.parse(map['dateTime']),
        recurring: bool.fromEnvironment(map['recurring']),
        note: map['note'] == null ? null : Note(map['note']));
  }

  factory Expense.fromSpringMap(Map<String, dynamic> map) {
    return Expense(
        localId: UserId(1),
        medium: map["type"] ?? "Cash",
        amount: Amount("${map["amount"]}"),
        category: Category("${map["category"]}"),
        dateTime: DateTime.parse("${map['dateAdded']}"),
        recurring: bool.fromEnvironment("false"),
        note: map['description'] == null ? null : Note(map['description']!));
  }

  Expense toDExpense() {
    return Expense(
      localId: localId,
      amount: amount,
      dateTime: dateTime,
      category: category,
      recurring: recurring,
      note: note,
      medium: medium,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": localId.value,
      "amount": amount.value.fold((l) => null, (r) => r),
      "category": category.value.fold((l) => null, (r) => r),
      "dateTime": dateTime.toIso8601String(),
      "recurring": recurring.toString(),
      "note": note != null ? note!.value.fold((l) => null, (r) => r) : null,
      "medium": medium.toString(),
    };
  }

  Map<String, dynamic> toSpringMap() {
    return {
      "amount": amount.value.fold((l) => null, (r) => r),
      "category": category.value.fold((l) => null, (r) => r),
      "dateAdded": dateTime.toIso8601String(),
      // "recurring": recurring.toString(),
      "description": note != null ? note!.value.fold((l) => null, (r) => r) : null,
      "type": medium.toString(),
    };
  }

  Map<String, dynamic> toBufferMap() {
    return {
      "userId": localId.value,
      "amount": amount.value.fold((l) => null, (r) => r),
      "category": category.value.fold((l) => null, (r) => r),
      "dateTime": dateTime.toIso8601String(),
      "recurring": recurring.toString(),
      "note": note != null ? note!.value.fold((l) => null, (r) => r) : null,
      "medium": medium.toString(),
      "transactionType": "expense"
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [amount, category, note, dateTime, recurring, medium];
}
