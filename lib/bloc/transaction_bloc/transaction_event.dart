part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable{
  const TransactionEvent();
}
class AddTransaction extends TransactionEvent{
  final AddExpenseInput addExpenseInput;
  const AddTransaction({required this.addExpenseInput});

  @override
  List<Object> get props => [addExpenseInput];
}
