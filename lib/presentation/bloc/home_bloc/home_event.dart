part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}
class LoadTransactionEvent extends HomeEvent{
  const LoadTransactionEvent();

  @override
  List<Object?> get props => [];
}
class LoadTransactionsThisMonthEvent extends HomeEvent{
  const LoadTransactionsThisMonthEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactionsLastMonthEvent extends HomeEvent{
  const LoadTransactionsLastMonthEvent();

  @override
  List<Object?> get props => [];
}
class LoadTransactionsLast3MonthEvent extends HomeEvent{
  const LoadTransactionsLast3MonthEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactionsLast6MonthEvent extends HomeEvent{
  const LoadTransactionsLast6MonthEvent();

  @override
  List<Object?> get props => [];
}
class LoadTransactionsCustomEvent extends HomeEvent{
  final DateTime startDate,endDate;
  const LoadTransactionsCustomEvent({required this.startDate,required this.endDate});

  @override
  List<Object?> get props => [startDate,endDate];
}

class SyncTransactionEvent extends HomeEvent{
  const SyncTransactionEvent();

  @override
  List<Object?> get props => [];
}