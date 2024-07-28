import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_manager/domain/value_objects/user/value_objects.dart';

part 'auth_form_event.dart';
part 'auth_form_state.dart';

class AuthFormBloc extends Bloc<AuthFormEvent, AuthFormState> {
  AuthFormBloc() : super(AuthFormState.initial()) {
    on<ChangeEmailEvent>((event, emit) {
      emit(state.copyWith(email: Email(event.email)));
    });
    on<ChangePasswordEvent>((event, emit) {
      emit(state.copyWith(password: Password(event.password)));
      add(ChangeConfirmPassword(confirmPassword: state.confirmPassword.password.fold((l) => '', (r) => r)));
    });
    on<ChangeNameEvent>((event, emit) {
      emit(state.copyWith(name: Name(event.name)));
    });
    on<Invalidate>((event, emit) {
      emit(state.copyWith(isValid: false));
    });
    on<ChangeConfirmPassword>((event, emit) {
      if (event.confirmPassword.isNotEmpty) {
        emit(state.copyWith(
            confirmPassword:
                Password.signUp(state.password.password.fold((l) => '', (r) => r), event.confirmPassword)));
      }
    });
    on<ValidateSignIn>((event, emit) {
      emit(state.copyWith(isValid: false));
      if (state.email.email.isRight() && state.password.password.isRight()) {
        emit(state.copyWith(isValid: true));
      }
    });
    on<ValidateSignUp>((event, emit) {
      emit(state.copyWith(isValid: !state.isValid));
      if (state.email.email.isRight() &&
          state.password.password.isRight() &&
          state.confirmPassword.password.isRight() &&
          state.name.name.isRight()) {
        emit(state.copyWith(isValid: true));
      } else {
        emit(state.copyWith(isValid: false));
      }
    });

    // on<SwitchAuthEvent>((event, emit) async {
    //   if (state.signUp) {
    //     emit(state.copyWith(signUp: false));
    //   } else {
    //     emit(state.copyWith(signUp: true));
    //   }
    // });
  }
}
