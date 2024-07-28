import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../application/boundaries/get_transactions/transaction_dto.dart';
import '../../../../application/usecases/transaction_view/map_transaction_usecase.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final MapTransactionUseCase _mapTransactionUseCase;

  TransactionBloc()
      : _mapTransactionUseCase = MapTransactionUseCase(),
        super(TransactionInitial()) {
    on<TransactionInput>((event, emit) async {
      emit(TransactionLoading());
      var transactions = await _mapTransactionUseCase.generateOutput(event.transactionList);
      debugPrint(transactions.toString());
      emit(TransactionLoaded(transactions: transactions, syncLoading: false, filter: "All"));
    });
  }
}
