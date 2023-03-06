part of 'transaction_form_bloc.dart';

abstract class TransactionFormEvent extends Equatable {
  const TransactionFormEvent();
}

class AddTransaction extends TransactionFormEvent {
  final UserId id;
  const AddTransaction({required this.id});
  @override
  List<Object> get props => [id];
}

class ChangeAmountEvent extends TransactionFormEvent {
  final String amount;
  const ChangeAmountEvent({required this.amount});
  @override
  List<Object?> get props => [amount];
}

class ChangeNoteEvent extends TransactionFormEvent {
  final String note;
  const ChangeNoteEvent({required this.note});
  @override
  List<Object?> get props => [note];
}

class ChangeCategoryEvent extends TransactionFormEvent {
  final String category;
  const ChangeCategoryEvent({required this.category});
  @override
  List<Object?> get props => [category];
}

class ChangeDateEvent extends TransactionFormEvent {
  final DateTime date;
  const ChangeDateEvent({required this.date});
  @override
  List<Object?> get props => [date];
}

class FlipIncome extends TransactionFormEvent {
  @override
  List<Object?> get props => [];
}

class FlipExpense extends TransactionFormEvent {
  @override
  List<Object?> get props => [];
}

class LoadCategoryEvent extends TransactionFormEvent {
  @override
  List<Object?> get props => [];
}
