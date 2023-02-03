import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_manager/domain/models/user_model.dart';
import 'package:money_manager/infrastructure/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../application/usecases/generate_user_use_case.dart';
import '../../../application/usecases/get_user_use_case.dart';
import '../../../application/usecases/user/update_user_usecase.dart';
import '../../../domain/value_objects/user/value_objects.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();

  final GenerateUserUseCase _generateUserUseCase;
  final GetUserUseCase _getUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;

  UserBloc({required UserRepository userRepository})
      : _generateUserUseCase = GenerateUserUseCase(userRepository),
        _updateUserUseCase = UpdateUserUseCase(userRepository: userRepository),
        _getUserUseCase = GetUserUseCase(userRepository),
        super(UserNotLoaded()) {

    ///INIT USER EVENT
    on<InitUser>((event, emit) async {
      User user;
      SharedPreferences sharedPreferences = await _sharedPreferences;
      if (sharedPreferences.getBool("firstRun") ?? true) {
        user = await _generateUserUseCase.execute();
        emit(UserLoaded(
            loggedIn: false,
            balance: user.balance,
            expense: user.expense,
            income: user.income,
            localId: user.localId,
            firstRun: true,
            remoteId: user.remoteId));
        await sharedPreferences.setBool("firstRun", false);
      } else {
        user = await _getUserUseCase.execute();
        emit(UserLoaded(
            loggedIn: false,
            balance: user.balance,
            expense: user.expense,
            income: user.income,
            localId: user.localId,
            firstRun: false,
            remoteId: user.remoteId));
      }
    });

    ///USER LOGIN EVENT
    on<LogUserIn>(((event, emit) async {
      var st = state as UserLoaded;
      await _updateUserUseCase.execute(remoteId: event.remoteId);
      emit(st.copyWith(remoteId: event.remoteId, loggedIn: true));
    }));

    ///RELOADING USER BALANCE FROM TRANSACTION VIEW
    on<ReloadUserBalance>((event, emit) async {
      if (state is UserLoaded) {
        var st = state as UserLoaded;
        emit(st.copyWith(balance: event.balance, income: event.income, expense: event.expense));
      }
    });
  }
}
