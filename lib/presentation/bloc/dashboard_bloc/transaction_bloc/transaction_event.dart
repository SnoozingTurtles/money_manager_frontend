part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class TransactionInput extends TransactionEvent {
  final List<TransactionDTO> transactionList;
  TransactionInput({required this.transactionList});
  @override
  List<Object?> get props => [];
}
