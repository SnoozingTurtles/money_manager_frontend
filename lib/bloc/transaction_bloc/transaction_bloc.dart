import 'package:bloc/bloc.dart';
import 'package:money_manager/application/boundaries/add_transaction/add_transaction_input.dart';
import 'package:money_manager/application/usecases/add_transaction_usecase.dart';
import 'package:money_manager/domain/factory/IEntityFactory.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/repositories/ITransactionRepository.dart';
import 'package:money_manager/infrastructure/repository/model_repository.dart';
import 'package:equatable/equatable.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final AddTransactionUseCase _addTransactionUseCase;
  TransactionBloc(
      {required ITransactionRepository iTransactionRepository,
      required IEntityFactory iEntityFactory})
      : _addTransactionUseCase = AddTransactionUseCase(
            transactionRepository: iTransactionRepository,
            entityFactory: iEntityFactory),
        super(InitialState()) {
    on<AddTransaction>(
        (AddTransaction event, Emitter<TransactionState> emit) async {
      emit(LoadingState());
      AddExpenseInput expenseInput = event.addExpenseInput;
      _addTransactionUseCase.execute(expenseInput);
      emit(InitialState());
    });
  }
}
