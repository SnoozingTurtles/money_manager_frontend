import 'package:bloc/bloc.dart';
import 'package:money_manager/application/boundaries/add_transaction/add_transaction_input.dart';
import 'package:money_manager/application/usecases/add_transaction_usecase.dart';
import 'package:money_manager/domain/factory/IEntityFactory.dart';
import 'package:money_manager/domain/repositories/ITransactionRepository.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';
import 'package:equatable/equatable.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final AddTransactionUseCase _addTransactionUseCase;
  TransactionBloc({required ITransactionRepository iTransactionRepository, required IEntityFactory iEntityFactory})
      : _addTransactionUseCase =
            AddTransactionUseCase(transactionRepository: iTransactionRepository, entityFactory: iEntityFactory),
        super(TransactionState.initial()) {
    on<AddTransaction>((event, emit) async {
      AddExpenseInput addExpenseInput = AddExpenseInput(
          amount: state.amount,
          category: state.category,
          dateTime: state.dateTime,
          recurring: state.recurring,
          note: state.note,
          medium: state.medium);

      var output = await _addTransactionUseCase.execute(addExpenseInput);

      output.fold((l) {
        state.copyWith(error: l.message);
        throw Exception(l.message);
      }, (r) => r);
    });
    on<ChangeAmountEvent>((event, emit) {
      emit(state.copyWith(amount: Amount(event.amount)));
    });
    on<ChangeCategoryEvent>((event, emit) {
      print('##${event.category}');
      emit(state.copyWith(category: Category(event.category)));
    });
    on<ChangeNoteEvent>((event, emit) {
      emit(state.copyWith(note: Note(event.note)));
    });
    on<ChangeDateEvent>((event,emit){
      emit(state.copyWith(dateTime: event.date));
    });
  }
}
