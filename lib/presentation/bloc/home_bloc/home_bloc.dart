import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_manager/application/boundaries/get_all_transactions/get_all_transaction_output.dart';
import 'package:money_manager/application/boundaries/get_all_transactions/transaction_dto.dart';
import 'package:money_manager/application/usecases/get_all_transaction_usecase.dart';
import 'package:money_manager/domain/repositories/ITransactionRepository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAllTransactionUseCase _getAllTransactionUseCase;

  HomeBloc({required ITransactionRepository iTransactionRepository}): _getAllTransactionUseCase = GetAllTransactionUseCase(
            iTransactionRepository: iTransactionRepository),
        super(HomeInitial()) {

    on<LoadTransactionEvent>((event, emit) async {
      emit(HomeLoading());
      GetAllTransactionOutput getAllTransactionOutput =
          await _getAllTransactionUseCase.execute();
      var transactions = getAllTransactionOutput.transactions;
      emit(HomeLoaded(transactions));
    });
  }
}
