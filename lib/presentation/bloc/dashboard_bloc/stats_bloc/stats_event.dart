part of 'stats_bloc.dart';

abstract class StatsEvent extends Equatable {}

class MapCategoryEvent extends StatsEvent {
  final List<TransactionDTO> categoryMap;

  MapCategoryEvent({required this.categoryMap});

  @override
  List<Object> get props => [categoryMap];
}
