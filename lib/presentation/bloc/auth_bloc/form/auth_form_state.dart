part of 'auth_form_bloc.dart';

@immutable
class AuthFormState extends Equatable {
  final Email email;
  final Password password;

  const AuthFormState({
    required this.email,
    required this.password,
  });

  factory AuthFormState.initial() {
    return AuthFormState(email: Email(''), password: Password(''));
  }
  @override
  List<Object> get props => [email, password];

  AuthFormState copyWith({Email? email, Password? password}) {
    return AuthFormState(email: email ?? this.email, password: password ?? this.password);
  }
}
