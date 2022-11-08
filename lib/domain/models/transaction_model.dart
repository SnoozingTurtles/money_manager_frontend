abstract class Transaction {
  int amount;
  String category; //Income category
  String? note;
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
      {required int amount,
      required String category,
      required String note,
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
      {required int amount,
      required String category,
      String? note,
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
