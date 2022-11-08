part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable{
  const TransactionState();
}
class InitialState extends TransactionState{
  @override
  List<Object> get props =>[];
}
class LoadingState extends TransactionState{
  @override
  List<Object?> get props => [];

}