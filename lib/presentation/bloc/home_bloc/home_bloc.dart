import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_manager/application/boundaries/get_transactions/get_transaction_output.dart';
import 'package:money_manager/application/boundaries/get_transactions/transaction_dto.dart';
import 'package:money_manager/application/usecases/get_transaction_usecase.dart';
import 'package:money_manager/application/usecases/sync_transaction_usecase.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';

import '../user_bloc/user_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAllTransactionUseCase _getAllTransactionUseCase;
  final SyncAllTransactionUseCase _syncTransactionUseCase;
  late StreamSubscription<bool> subscription;
  final UserBloc _userBloc;
  HomeBloc({required TransactionRepository transactionRepository, required UserBloc userBloc})
      : _getAllTransactionUseCase = GetAllTransactionUseCase(iTransactionRepository: transactionRepository),
        _syncTransactionUseCase = SyncAllTransactionUseCase(transactionRepository: transactionRepository),
        _userBloc = userBloc,
        super(HomeInitial()) {
    subscription = transactionRepository.connectivityStream.listen((event) {
      print("EVENT FROM STREAM");
      print("Event is $event");
      if (event) {
        add(const SyncTransactionEvent());
      }
    });
    on<SyncTransactionEvent>((event, emit) async {
      if (state is HomeLoaded) {
        emit((state as HomeLoaded).copyWith(syncLoading: true));
        await _syncTransactionUseCase.execute();
        emit((state as HomeLoaded).copyWith(syncLoading: false));
      }
    });
    on<LoadTransactionEvent>((event, emit) async {
      emit(HomeLoading());
      GetAllTransactionOutput getAllTransactionOutput = await _getAllTransactionUseCase.executeAllTime();
      var transactions = getAllTransactionOutput.transactions;
      _userBloc.add(LoadUser());
      emit(HomeLoaded(transactions: transactions, syncLoading: false, filter: "All Time"));
    });
    on<LoadTransactionsThisMonthEvent>((event, emit) async {
      emit(HomeLoading());
      GetAllTransactionOutput getAllTransactionOutput = await _getAllTransactionUseCase.executeThisMonth();
      var transactions = getAllTransactionOutput.transactions;
      _reloadUserBalance(transactions.values);
      emit(HomeLoaded(transactions: transactions, syncLoading: false, filter: "This Month"));
    });
    on<LoadTransactionsLastMonthEvent>((event, emit) async {
      emit(HomeLoading());
      GetAllTransactionOutput getAllTransactionOutput = await _getAllTransactionUseCase.executeLastMonth();
      var transactions = getAllTransactionOutput.transactions;
      _reloadUserBalance(transactions.values);
      emit(HomeLoaded(transactions: transactions, syncLoading: false, filter: "Last Month"));
    });
    on<LoadTransactionsLast3MonthEvent>((event, emit) async {
      emit(HomeLoading());
      GetAllTransactionOutput getAllTransactionOutput = await _getAllTransactionUseCase.executeLast3Months();
      var transactions = getAllTransactionOutput.transactions;
      _reloadUserBalance(transactions.values);
      emit(HomeLoaded(transactions: transactions, syncLoading: false, filter: "Last 3 Months"));
    });
    on<LoadTransactionsLast6MonthEvent>((event, emit) async {
      emit(HomeLoading());
      GetAllTransactionOutput getAllTransactionOutput = await _getAllTransactionUseCase.executeLast6Months();
      var transactions = getAllTransactionOutput.transactions;
      _reloadUserBalance(transactions.values);
      emit(HomeLoaded(transactions: transactions, syncLoading: false, filter: "Last 6 Months"));
    });
    on<LoadTransactionsCustomEvent>((event, emit) async {
      emit(HomeLoading());
      GetAllTransactionOutput getAllTransactionOutput = await _getAllTransactionUseCase.executeCustom(
          event.startDate.toIso8601String(), event.endDate.toIso8601String());
      var transactions = getAllTransactionOutput.transactions;
      _reloadUserBalance(transactions.values);
      emit(HomeLoaded(
          transactions: transactions,
          syncLoading: false,
          filter:
              "${event.startDate.toString().substring(0, 10)} to ${event.endDate.toString().substring(0, 10)}"));
    });
  }

  void _reloadUserBalance(Iterable<List<TransactionDTO>> transactions) {
    double expense = 0, income = 0;
    for (var value in transactions) {
      for (var element in value) {
        if (element is IncomeDTO) {
          income += element.amount.value.fold((l) => 0, (r) => double.parse(r));
        } else {
          expense += element.amount.value.fold((l) => 0, (r) => double.parse(r));
        }
      }
    }
    _userBloc.add(ReloadUser(balance: income - expense, income: income, expense: expense));
  }
}
