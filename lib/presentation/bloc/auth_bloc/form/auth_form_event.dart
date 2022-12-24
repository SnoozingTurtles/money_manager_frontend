part of 'auth_form_bloc.dart';

@immutable
abstract class AuthFormEvent {
  const AuthFormEvent();
}

class ChangeEmailEvent extends AuthFormEvent {
  final String email;
  const ChangeEmailEvent({required this.email});
  @override
  List<Object?> get props => [email];
}

class ChangePasswordEvent extends AuthFormEvent {
  final String password;
  const ChangePasswordEvent({required this.password});
  @override
  List<Object?> get props => [password];
}

class SwitchAuthEvent extends AuthFormEvent{
  const SwitchAuthEvent();

  @override
  List<Object?> get props => [];
}
