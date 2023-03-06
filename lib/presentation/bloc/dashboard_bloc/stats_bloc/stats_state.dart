part of 'stats_bloc.dart';

@immutable
abstract class StatsState extends Equatable {}

class StatsInitial extends StatsState {
  @override
  List<Object> get props => [];
}

class StatsLoaded extends StatsState {
  final Map<Category, int> categoryMapping;

  StatsLoaded({required this.categoryMapping});

  StatsLoaded copyWith(Map<Category, int>? categoryMapping) {
    return StatsLoaded(categoryMapping: categoryMapping ?? this.categoryMapping);
  }

  @override
  List<Object> get props => [categoryMapping];
}

class StatsLoading extends StatsState {
  @override
  List<Object> get props => [];
}
