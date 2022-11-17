import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_manager/application/boundaries/get_all_transactions/get_all_transaction_output.dart';
import 'package:money_manager/application/boundaries/get_all_transactions/transaction_dto.dart';
import 'package:money_manager/application/usecases/get_all_transaction_usecase.dart';
import 'package:money_manager/application/usecases/sync_transaction_usecase.dart';
import 'package:money_manager/domain/repositories/ITransactionRepository.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAllTransactionUseCase _getAllTransactionUseCase;
  final SyncAllTransactionUseCase _syncTransactionUseCase;
  late StreamSubscription<bool> subscription;
  HomeBloc({required TransactionRepository transactionRepository}): _getAllTransactionUseCase = GetAllTransactionUseCase(
            iTransactionRepository: transactionRepository),_syncTransactionUseCase = SyncAllTransactionUseCase(transactionRepository: transactionRepository),
        super(HomeInitial()) {
    subscription = transactionRepository.connectivityStream.listen((event) {
      print("EVENT FROM STREAM");
      print("Event is $event");
      if(event){
        add(const SyncTransactionEvent());
      }
    });
    on<SyncTransactionEvent>((event,emit)async{
      if(state is HomeLoaded) {

        emit((state as HomeLoaded).copyWith(syncLoading: true));
        await _syncTransactionUseCase.execute();
        emit((state as HomeLoaded).copyWith(syncLoading: false));
      }
    });
    on<LoadTransactionEvent>((event, emit) async {
      emit(HomeLoading());
      GetAllTransactionOutput getAllTransactionOutput =
          await _getAllTransactionUseCase.execute();
      var transactions = getAllTransactionOutput.transactions;
      emit(HomeLoaded(transactions:transactions,syncLoading:false));

    });

  }

}
