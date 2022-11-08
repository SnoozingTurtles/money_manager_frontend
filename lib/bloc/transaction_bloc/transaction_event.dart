part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable{
  const TransactionEvent();
}
class AddTransaction extends TransactionEvent{
  final Expense expense;
  const AddTransaction({required this.expense});

  @override
  List<Object> get props => [expense];
}
