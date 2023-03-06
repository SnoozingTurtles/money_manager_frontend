part of 'auth_form_bloc.dart';

@immutable
abstract class AuthFormEvent extends Equatable {
  const AuthFormEvent();
}

class ValidateSignUp extends AuthFormEvent {
  const ValidateSignUp();
  @override
  List<Object?> get props => [];
}
class ValidateSignIn extends AuthFormEvent {
  const ValidateSignIn();
  @override
  List<Object?> get props => [];
}

class Invalidate extends AuthFormEvent {
  const Invalidate();
  @override
  List<Object?> get props => [];
}
class ChangeEmailEvent extends AuthFormEvent {
  final String email;
  const ChangeEmailEvent({required this.email});
  @override
  List<Object?> get props => [email];
}

class ChangeNameEvent extends AuthFormEvent {
  final String name;
  const ChangeNameEvent({required this.name});
  @override
  List<Object?> get props => [name];
}

class ChangeConfirmPassword extends AuthFormEvent {
  final String confirmPassword;
  const ChangeConfirmPassword({required this.confirmPassword});
  @override
  List<Object?> get props => [confirmPassword];
}

class ChangePasswordEvent extends AuthFormEvent {
  final String password;
  const ChangePasswordEvent({required this.password});
  @override
  List<Object?> get props => [password];
}

class SwitchAuthEvent extends AuthFormEvent {
  const SwitchAuthEvent();

  @override
  List<Object?> get props => [];
}
