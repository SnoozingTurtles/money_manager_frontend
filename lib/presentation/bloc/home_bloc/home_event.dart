part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}
class LoadTransactionEvent extends HomeEvent{
  const LoadTransactionEvent();

  @override
  List<Object?> get props => [];
}
class SyncTransactionEvent extends HomeEvent{
  const SyncTransactionEvent();

  @override
  List<Object?> get props => [];
}