import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_manager/application/boundaries/add_transaction/add_transaction_input.dart';
import 'package:money_manager/application/usecases/add_transaction_usecase.dart';
import 'package:money_manager/application/usecases/categories/get_categories_use_case.dart';
import 'package:money_manager/application/usecases/get_transaction_usecase.dart';
import 'package:money_manager/common/secure_storage.dart';
import 'package:money_manager/domain/factory/i_entity_factory.dart';
import 'package:money_manager/domain/repositories/i_transaction_repository.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

import '../../../domain/value_objects/user/value_objects.dart';
import '../user_bloc/user_bloc.dart';

part 'transaction_form_event.dart';
part 'transaction_form_state.dart';

class TransactionFormBloc extends Bloc<TransactionFormEvent, TransactionFormState> {
  final AddTransactionUseCase _addTransactionUseCase;
  final GetCategoriesUseCase getCategoriesUseCase = GetCategoriesUseCase();
  final GetAllTransactionUseCase getAllTransactionUseCase;
  final UserBloc _userBloc;

  TransactionFormBloc({
    required ITransactionRepository iTransactionRepository,
    required IEntityFactory iEntityFactory,
    required UserBloc userBloc,
    required UserId localId,
  })  : _userBloc = userBloc,
        _addTransactionUseCase =
            AddTransactionUseCase(transactionRepository: iTransactionRepository, entityFactory: iEntityFactory),
        getAllTransactionUseCase = GetAllTransactionUseCase(iTransactionRepository: iTransactionRepository),
        super(TransactionFormState.initial(localId)) {
    on<AddTransaction>((event, emit) async {
      emit(state.copyWith(saving: true));
      AddTransactionInput addTransactionInput;
      var balance = (_userBloc.state as UserLoaded).balance;
      var income = (_userBloc.state as UserLoaded).income;
      var expense = (_userBloc.state as UserLoaded).expense;
      var remoteId = (_userBloc.state as UserLoaded).remoteId;
      var token = await SecureStorage().getToken();
      if (state.income) {
        addTransactionInput = AddIncomeInput(
            amount: state.amount,
            id: event.id,
            category: state.category,
            token: token,
            dateTime: state.dateTime,
            note: state.note,
            recurring: state.recurring);
        balance += state.amount.value.fold((l) => 0, (r) => double.parse(r));
        _userBloc.add(ReloadUserBalance(
            balance: balance,
            expense: expense,
            income: income + state.amount.value.fold((l) => 0, (r) => double.parse(r))));
      } else {
        addTransactionInput = AddExpenseInput(
            id: event.id,
            amount: state.amount,
            category: state.category,
            token: token,
            dateTime: state.dateTime,
            recurring: state.recurring,
            note: state.note,
            medium: state.medium);
        balance -= state.amount.value.fold((l) => 0, (r) => double.parse(r));
        _userBloc.add(ReloadUserBalance(
            balance: balance,
            income: income,
            expense: expense + state.amount.value.fold((l) => 0, (r) => double.parse(r))));
      }

      var output = await _addTransactionUseCase.execute(input: addTransactionInput, remoteId: remoteId);

      output.fold((l) {
        state.copyWith(error: l.message, saving: false);
        throw Exception(l.message);
      }, (r) => emit(state.copyWith(saving: false)));

      // _dashBoardBloc.add(const LoadTransactionsThisMonthEvent());
    });
    on<ChangeAmountEvent>((event, emit) {
      emit(state.copyWith(amount: Amount(event.amount)));
    });
    on<ChangeCategoryEvent>((event, emit) {
      emit(state.copyWith(category: Category(event.category)));
    });
    on<ChangeNoteEvent>((event, emit) {
      emit(state.copyWith(note: Note(event.note)));
    });
    on<ChangeDateEvent>((event, emit) {
      emit(state.copyWith(dateTime: event.date));
    });
    on<FlipIncome>((event, emit) {
      emit(state.copyWith(income: !state.income));
    });
    on<FlipExpense>((event, emit) {
      emit(state.copyWith(income: false));
    });
    on<LoadCategoryEvent>((event, emit) async {
      var transactions = await getAllTransactionUseCase.executeAllTime();
      var categories = getCategoriesUseCase.getCategories(transactions.transactions);
      emit(state.copyWith(availableCategories: categories));
    });
  }
}
