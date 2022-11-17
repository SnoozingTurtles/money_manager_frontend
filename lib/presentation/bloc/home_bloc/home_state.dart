part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoaded extends HomeState {
  final UnmodifiableListView<TransactionDTO> transactions;
  final bool syncLoading;
  const HomeLoaded({required this.transactions,required this.syncLoading});

  HomeLoaded copyWith({bool? syncLoading}) {
    return HomeLoaded(transactions:transactions,syncLoading: syncLoading ?? this.syncLoading);
  }

  @override
  List<Object?> get props => [syncLoading];
}

class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}

