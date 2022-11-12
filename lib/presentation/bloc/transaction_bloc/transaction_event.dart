part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class AddTransaction extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class ChangeAmountEvent extends TransactionEvent {
  final String amount;
  const ChangeAmountEvent({required this.amount});
  @override
  List<Object?> get props => [amount];
}

class ChangeNoteEvent extends TransactionEvent {
  final String note;
  const ChangeNoteEvent({required this.note});
  @override
  List<Object?> get props => [note];
}

class ChangeCategoryEvent extends TransactionEvent {
  final String category;
  const ChangeCategoryEvent({required this.category});
  @override
  List<Object?> get props => [category];
}

class ChangeDateEvent extends TransactionEvent{
  final DateTime date;
  const ChangeDateEvent({required this.date});
  @override
  List<Object?> get props => [date];
}
