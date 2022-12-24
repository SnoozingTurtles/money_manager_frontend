import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:money_manager/domain/value_objects/user/value_objects.dart';

part 'auth_form_event.dart';
part 'auth_form_state.dart';

class AuthFormBloc extends Bloc<AuthFormEvent, AuthFormState> {
  AuthFormBloc() : super(AuthFormState.initial()) {
    on<ChangeEmailEvent>((event, emit) {
      emit(state.copyWith(email:Email(event.email)));
    });
    on<ChangePasswordEvent>((event, emit) {
      emit(state.copyWith(password:Password(event.password)));
    });

    on<SwitchAuthEvent>((event, emit) async {
      if (state.signUp) {
        emit(state.copyWith(signUp: false));
      } else {
        emit(state.copyWith(signUp:true));
      }
    });
  }
}
