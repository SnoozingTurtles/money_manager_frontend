import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';
import 'package:money_manager/domain/value_objects/user/value_objects.dart';

abstract class TransactionModel {
  UserId id;
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
        required this.recurring,
        required this.id});

}


class IncomeModel extends TransactionModel {
  IncomeModel(
      {required Amount amount,
        required UserId id,
        required Category category,
        Note? note,
        required DateTime dateTime,
        required bool recurring})
      : super(amount: amount, category: category, dateTime: dateTime, note: note, recurring: recurring, id: id);

  factory IncomeModel.fromMap(Map<String, dynamic> map) {
    return IncomeModel(
        amount: Amount(map["amount"]),
        id: UserId(map["userId"]),
        category: Category(map["category"]),
        dateTime: DateTime.parse(map['dateTime']),
        recurring: bool.fromEnvironment(map['recurring']),
        note: map['note'] == null ? null : Note(map['note']));
  }
  factory IncomeModel.fromSpringMap(Map<String, dynamic> map) {
    return IncomeModel(
        id: UserId(1),
        amount: Amount("${map["amount"]}"),
        category: Category("${map["category"]}"),
        dateTime: DateTime.parse("${map['dateAdded']}"),
        recurring: bool.fromEnvironment("false"),
        note: map['description'] == null ? null : Note(map['description']!));
  }

  Income toDIncome(){
    return Income(
      amount: amount,
      dateTime: dateTime,
      category: category,
      recurring: recurring,
      note: note,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "userId": id.value,
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
      "userId": id.value,
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
  List<Object?> get props => [];
}


class ExpenseModel extends TransactionModel {
  String medium; //account, cash, card
  ExpenseModel(
      {required Amount amount,
        required UserId id,
        required Category category,
        Note? note,
        String?token,
        required DateTime dateTime,
        required bool recurring,
        required this.medium})
      : super(amount: amount, category: category, dateTime: dateTime, note: note, recurring: recurring, id: id);

  @override
  String toString() {
    return "$amount";
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
        id: UserId(map["userId"]),
        medium: map["medium"] ?? "Cash",
        amount: Amount(map["amount"]),
        category: Category(map["category"]),
        dateTime: DateTime.parse(map['dateTime']),
        recurring: bool.fromEnvironment(map['recurring']),
        note: map['note'] == null ? null : Note(map['note']));
  }

  factory ExpenseModel.fromSpringMap(Map<String, dynamic> map) {
    return ExpenseModel(
        id: UserId(1),
        medium: map["type"] ?? "Cash",
        amount: Amount("${map["amount"]}"),
        category: Category("${map["category"]}"),
        dateTime: DateTime.parse("${map['dateAdded']}"),
        recurring: bool.fromEnvironment("false"),
        note: map['description'] == null ? null : Note(map['description']!));
  }

  Expense toDExpense(){
    return Expense(
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
      "userId": id.value,
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
      "userId": id.value,
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
  List<Object?> get props => [];
}