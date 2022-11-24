part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoaded extends HomeState {
  final SplayTreeMap<String,List<TransactionDTO>> transactions;
  final bool syncLoading;
  final String filter;
  const HomeLoaded({required this.transactions,required this.syncLoading,required this.filter});

  HomeLoaded copyWith({bool? syncLoading,String?filter}) {
    return HomeLoaded(transactions:transactions,syncLoading: syncLoading ?? this.syncLoading,filter: filter??this.filter);
  }

  @override
  List<Object?> get props => [syncLoading,filter];
}

class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}

