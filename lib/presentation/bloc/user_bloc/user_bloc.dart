import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_manager/domain/models/user_model.dart';
import 'package:money_manager/infrastructure/repository/user_repository.dart';

import '../../../application/usecases/generate_user_use_case.dart';
import '../../../application/usecases/get_user_use_case.dart';
import '../../../application/usecases/user/update_user_usecase.dart';
import '../../../domain/value_objects/user/value_objects.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  GenerateUserUseCase _generateUserUseCase;
  GetUserUseCase _getUserUseCase;
  UpdateUserUseCase _updateUserUseCase;
  UserBloc({required UserRepository userRepository})
      : _generateUserUseCase = GenerateUserUseCase(userRepository),
        _updateUserUseCase = UpdateUserUseCase(userRepository:userRepository),
        _getUserUseCase = GetUserUseCase(userRepository),
        super(UserNotLoaded()) {

    on<LogUserIn>(((event,emit)async{
      var st = state as UserLoaded;
      await _updateUserUseCase.execute(remoteId: event.remoteId);
      emit(st.copyWith(user: st.user.copyWith(remoteId: event.remoteId)));
    }));
    on<InitUser>((event, emit) async {
      User user = await _generateUserUseCase.execute();
      emit(UserLoaded(user:user));
    });
    on<ReloadUser>((event, emit) async {
      if (state is UserLoaded) {
        var st = state as UserLoaded;
        emit(
          (st).copyWith(
            user: st.user.copyWith(
              balance: event.balance,
              income: event.income,
              expense: event.expense,
            ),
          ),
        );
      }
    });
    on<LoadUser>((event, emit) async {
      // print("loading user");
      User user = await _getUserUseCase.execute();
      emit(UserLoaded(user:user));
    });
  }
}
