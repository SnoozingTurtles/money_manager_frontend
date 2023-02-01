part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

///LOCAL STATE
class AuthUninitialized extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthAuthenticated extends AuthState {
  // final String jwtToken,email;
  final UserId remoteId;
  const AuthAuthenticated({required this.remoteId});

  @override
  List<Object> get props => [remoteId];
}

class AuthUnauthenticated extends AuthState {
  final String error;
  const AuthUnauthenticated({required this.error});
  @override
  List<Object> get props => [];
}

///LOCAL STATE AUTH SCREEN USAGE ONLY
class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}
