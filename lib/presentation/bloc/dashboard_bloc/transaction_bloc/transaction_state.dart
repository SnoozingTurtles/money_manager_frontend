part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
}

class TransactionInitial extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionLoaded extends TransactionState {
  final SplayTreeMap<String, List<TransactionDTO>> transactions;
  final bool syncLoading;
  final String filter;
  const TransactionLoaded({required this.transactions, required this.syncLoading, required this.filter});

  TransactionLoaded copyWith({bool? syncLoading, String? filter}) {
    return TransactionLoaded(
        transactions: transactions, syncLoading: syncLoading ?? this.syncLoading, filter: filter ?? this.filter);
  }

  @override
  List<Object?> get props => [ syncLoading, filter];
}

class TransactionLoading extends TransactionState {
  @override
  List<Object> get props => [];
}
