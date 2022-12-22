part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthUninitialized extends AuthState {
  @override
  List<Object> get props => [];
}
class AuthAuthenticated extends AuthState{
  // final String jwtToken,email;
  const AuthAuthenticated();

  @override
  List<Object> get props => [];
}
class AuthUnauthenticated extends AuthState{
  @override
  List<Object> get props => [];
}
class AuthPassed extends AuthState{
  @override
  List<Object> get props => [];
}
class AuthLoading extends AuthState{
  @override
  List<Object> get props => [];
}
class AuthSignIn extends AuthState{
  @override
  List<Object> get props => [];
}
class AuthSignUp extends AuthState{
  @override
  List<Object> get props => [];
}
