import 'package:bloc/bloc.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/infrastructure/repository/model_repository.dart';
import 'package:equatable/equatable.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final ModelRepository _modelRepository;
  TransactionBloc(this._modelRepository)
      : super(InitialState()) {
    on<AddTransaction>((AddTransaction event, Emitter<TransactionState> emit) async {
      emit(LoadingState());
      await _modelRepository.addTransaction(event.expense);
      emit(InitialState());
    });
  }
}
