import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:money_manager/application/boundaries/get_transactions/get_transaction_output.dart';
import 'package:money_manager/application/boundaries/get_transactions/transaction_dto.dart';
import 'package:money_manager/application/usecases/get_transaction_usecase.dart';
import 'package:money_manager/application/usecases/sync_transaction_usecase.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';

import '../../../common/secure_storage.dart';
import '../user_bloc/user_bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  final GetAllTransactionUseCase _getAllTransactionUseCase;
  final SyncAllTransactionUseCase _syncTransactionUseCase;
  late StreamSubscription<InternetConnectionStatus> subscription;
  final UserBloc _userBloc;
  DashBoardBloc({required TransactionRepository transactionRepository, required UserBloc userBloc})
      : _getAllTransactionUseCase = GetAllTransactionUseCase(iTransactionRepository: transactionRepository),
        _syncTransactionUseCase = SyncAllTransactionUseCase(transactionRepository: transactionRepository),
        _userBloc = userBloc,
        super(DashBoardInitial()) {
    SecureStorage secureStorage = SecureStorage();
    subscription = InternetConnectionChecker().onStatusChange.listen((status) async {
      debugPrint("CONNECTIVITY EVENT is $status");
      if (status == InternetConnectionStatus.connected && await secureStorage.hasToken()) {
        add(const SyncTransactionEvent());
      }
    });
    on<SyncTransactionEvent>((event, emit) async {
      if (state is DashBoardLoaded) {
        emit((state as DashBoardLoaded).copyWith(syncLoading: true));
        await _syncTransactionUseCase.executeLocalToRemote();
        emit((state as DashBoardLoaded).copyWith(syncLoading: false));
      }
    });
    on<LoadTransactionEvent>((event, emit) async {
      emit(DashBoardLoading());
      GetAllTransactionOutput getAllTransactionOutput = await _getAllTransactionUseCase.executeAllTime();
      var transactions = getAllTransactionOutput.transactions;
      await _reloadUserBalance(transactions);
      emit(DashBoardLoaded(transactions: transactions, syncLoading: false, filter: "All Time"));
    });
    on<LoadTransactionsThisMonthEvent>((event, emit) async {
      emit(DashBoardLoading());
      GetAllTransactionOutput getAllTransactionOutput = await _getAllTransactionUseCase.executeThisMonth();
      var transactions = getAllTransactionOutput.transactions;
      await _reloadUserBalance(transactions);
      emit(DashBoardLoaded(transactions: transactions, syncLoading: false, filter: "This Month"));
    });
    on<LoadTransactionsLastMonthEvent>((event, emit) async {
      emit(DashBoardLoading());
      GetAllTransactionOutput getAllTransactionOutput = await _getAllTransactionUseCase.executeLastMonth();
      var transactions = getAllTransactionOutput.transactions;
      await _reloadUserBalance(transactions);
      emit(DashBoardLoaded(transactions: transactions, syncLoading: false, filter: "Last Month"));
    });
    on<LoadTransactionsLast3MonthEvent>((event, emit) async {
      emit(DashBoardLoading());
      GetAllTransactionOutput getAllTransactionOutput = await _getAllTransactionUseCase.executeLast3Months();
      var transactions = getAllTransactionOutput.transactions;
      await _reloadUserBalance(transactions);
      emit(DashBoardLoaded(transactions: transactions, syncLoading: false, filter: "Last 3 Months"));
    });
    on<LoadTransactionsLast6MonthEvent>((event, emit) async {
      emit(DashBoardLoading());
      GetAllTransactionOutput getAllTransactionOutput = await _getAllTransactionUseCase.executeLast6Months();
      var transactions = getAllTransactionOutput.transactions;
      await _reloadUserBalance(transactions);
      emit(DashBoardLoaded(transactions: transactions, syncLoading: false, filter: "Last 6 Months"));
    });
    on<LoadTransactionsCustomEvent>((event, emit) async {
      emit(DashBoardLoading());
      GetAllTransactionOutput getAllTransactionOutput = await _getAllTransactionUseCase.executeCustom(
          event.startDate.toIso8601String(), event.endDate.toIso8601String());
      var transactions = getAllTransactionOutput.transactions;
      await _reloadUserBalance(transactions);
      emit(DashBoardLoaded(transactions: transactions, syncLoading: false, filter: "custom"));
    });
  }

  Future<void> _reloadUserBalance(List<TransactionDTO> transactions) async {
    double expense = 0, income = 0;
    for (var element in transactions) {
      if (element is IncomeDTO) {
        income += element.amount.value.fold((l) => 0, (r) => double.parse(r));
      } else {
        expense += element.amount.value.fold((l) => 0, (r) => double.parse(r));
      }
    }
    _userBloc.add(ReloadUserBalance(balance: income - expense, income: income, expense: expense));
  }
}
