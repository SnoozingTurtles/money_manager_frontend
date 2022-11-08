part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoaded extends HomeState {
  final List<Transaction> transactions;

  const HomeLoaded(this.transactions);
  @override
  List<Object?> get props => [transactions];
}

class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}
