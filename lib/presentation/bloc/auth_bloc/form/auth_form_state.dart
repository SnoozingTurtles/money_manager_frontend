part of 'auth_form_bloc.dart';

@immutable
class AuthFormState extends Equatable {
  final Name name;
  final Email email;
  final Password password;
  final Password confirmPassword;
  final bool isValid;
  const AuthFormState(
      {required this.name,
      required this.email,
      required this.password,
      required this.isValid,
      required this.confirmPassword});

  factory AuthFormState.initial() {
    return AuthFormState(
        email: Email(''),
        password: Password(''),
        isValid: false,
        name: Name(''),
        confirmPassword: Password.signUp('', ''));
  }
  @override
  List<Object> get props => [email, password, isValid, name, confirmPassword];

  AuthFormState copyWith({Email? email, Password? password, bool? isValid, Password? confirmPassword, Name? name}) {
    return AuthFormState(
        name: name ?? this.name,
        email: email ?? this.email,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        password: password ?? this.password,
        isValid: isValid ?? this.isValid);
  }
}
