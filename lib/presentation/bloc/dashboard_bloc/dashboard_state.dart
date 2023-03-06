part of 'dashboard_bloc.dart';

abstract class DashBoardState extends Equatable {
  const DashBoardState();
}

class DashBoardInitial extends DashBoardState {
  @override
  List<Object> get props => [];
}

class DashBoardLoaded extends DashBoardState {
  final List<TransactionDTO> transactions;
  final bool syncLoading;
  final String filter;
  const DashBoardLoaded({required this.transactions, required this.syncLoading, required this.filter});

  DashBoardLoaded copyWith({bool? syncLoading, String? filter}) {
    return DashBoardLoaded(
        transactions: transactions, syncLoading: syncLoading ?? this.syncLoading, filter: filter ?? this.filter);
  }

  @override
  List<Object?> get props => [ syncLoading, filter];
}

class DashBoardLoading extends DashBoardState {
  @override
  List<Object> get props => [];
}
