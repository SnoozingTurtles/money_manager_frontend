import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/infrastructure/repository/model_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  ModelRepository _modelRepository;

  HomeBloc(this._modelRepository) : super(HomeInitial()) {
    on<LoadTransactionEvent>((event, emit) async{
      emit(HomeLoading());
      List<Transaction> list = await _modelRepository.getTransactions();
      emit(HomeLoaded(list));
    });
  }
}
