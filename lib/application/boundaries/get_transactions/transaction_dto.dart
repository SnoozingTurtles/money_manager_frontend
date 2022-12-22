import 'package:equatable/equatable.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

abstract class TransactionDTO extends Equatable{
  final Amount amount;
  final Category category; //IncomeDTO category
  final Note? note;
  final DateTime dateTime;
  final bool recurring;
  final String?token;

  TransactionDTO(
      {required this.amount,
        required this.category,
         this.token,
        this.note,
        required this.dateTime,
        required this.recurring});

}

class IncomeDTO extends TransactionDTO {
  IncomeDTO(
      {required Amount amount,
        String?token,
        required Category category,
        Note? note,
        required DateTime dateTime,
        required bool recurring})
      : super(
      amount: amount,
      token:token,
      category: category,
      dateTime: dateTime,
      note: note,
      recurring: recurring);

  IncomeDTO.fromEntity(Transaction transaction)
      : this(
      amount: transaction.amount,
      category: transaction.category,
      token:transaction.token,
      dateTime: transaction.dateTime,
      recurring: transaction.recurring,
      note: transaction.note);
  @override
  // TODO: implement props
  List<Object?> get props => [amount,category,note,dateTime,recurring];
}

class ExpenseDTO extends TransactionDTO {
  String medium; //account, cash, card
  ExpenseDTO(
      {required Amount amount,
        required Category category,
        Note? note,
        String?token,
        required DateTime dateTime,
        required bool recurring,
        required this.medium})
      : super(
      amount: amount,
      category: category,
      token:token,
      dateTime: dateTime,
      note: note,
      recurring: recurring);

  ExpenseDTO.fromEntity(Transaction transaction)
      : this(
      amount: transaction.amount,
      category: transaction.category,
      dateTime: transaction.dateTime,
      token:transaction.token,
      recurring: transaction.recurring,
      medium: "Cash",
      note: transaction.note);

  // @override
  // String toString() {
  //   return "$amount";
  // }

  @override
  // TODO: implement props
  List<Object?> get props => [amount,category,dateTime,recurring,note];
}
