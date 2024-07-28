import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_manager/application/usecases/categories/group_categories_use_case.dart';

import '../../../../application/boundaries/get_transactions/transaction_dto.dart';
import '../../../../domain/value_objects/transaction/value_objects.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  GroupByCategoriesUseCase groupByCategoriesUseCase = GroupByCategoriesUseCase();
  StatsBloc() : super(StatsInitial()) {
    on<MapCategoryEvent>((event, emit) {
      emit(StatsLoading());
      Map<Category, List<TransactionDTO>> map = groupByCategoriesUseCase.execute(event.categoryMap);
      Map<Category, int> output = {};
      map.forEach((key, value) {
        int amount = 0;
        for (var element in value) {
          amount += element.amount.value.fold((l) => 0, (r) => int.parse(r));
        }
        output[key] = amount;
      });
      emit(StatsLoaded(categoryMapping: output));
    });
  }
}
