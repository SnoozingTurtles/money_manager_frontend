part of 'dashboard_bloc.dart';

abstract class DashBoardEvent extends Equatable {
  const DashBoardEvent();
}
class LoadTransactionEvent extends DashBoardEvent{
  const LoadTransactionEvent();

  @override
  List<Object?> get props => [];
}
class LoadTransactionsThisMonthEvent extends DashBoardEvent{
  const LoadTransactionsThisMonthEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactionsLastMonthEvent extends DashBoardEvent{
  const LoadTransactionsLastMonthEvent();

  @override
  List<Object?> get props => [];
}
class LoadTransactionsLast3MonthEvent extends DashBoardEvent{
  const LoadTransactionsLast3MonthEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactionsLast6MonthEvent extends DashBoardEvent{
  const LoadTransactionsLast6MonthEvent();

  @override
  List<Object?> get props => [];
}
class LoadTransactionsCustomEvent extends DashBoardEvent{
  final DateTime startDate,endDate;
  const LoadTransactionsCustomEvent({required this.startDate,required this.endDate});

  @override
  List<Object?> get props => [startDate,endDate];
}

class SyncTransactionEvent extends DashBoardEvent{
  const SyncTransactionEvent();

  @override
  List<Object?> get props => [];
}