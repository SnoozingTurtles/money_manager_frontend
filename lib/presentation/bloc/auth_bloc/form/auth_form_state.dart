part of 'auth_form_bloc.dart';

@immutable
class AuthFormState extends Equatable {
  final Email email;
  final Password password;
  final bool signUp;
  const AuthFormState({
    required this.email,
    required this.password,
    required this.signUp,
  });

  factory AuthFormState.initial() {
    return AuthFormState(email: Email(''), password: Password(''),signUp: true);
  }
  @override
  List<Object> get props => [email, password,signUp];

  AuthFormState copyWith({Email? email, Password? password,bool?signUp}) {
    return AuthFormState(email: email ?? this.email, password: password ?? this.password,signUp:signUp??this.signUp);
  }
}
