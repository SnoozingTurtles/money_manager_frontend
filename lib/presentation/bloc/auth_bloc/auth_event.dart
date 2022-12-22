part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}
class AuthInitialEvent extends AuthEvent {
  const AuthInitialEvent();
  @override
  List<Object?> get props => [];
}
class SignInEvent extends AuthEvent{
  final Email email;
  final Password password;
  const SignInEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [email,password];
}
class SignUpEvent extends AuthEvent{
  final Email email;
  final Password password;
  final String name;

  const SignUpEvent({required this.email, required this.password,required this.name});

  @override
  List<Object?> get props => [email,password,name];
}
class SyncRemoteToLocal extends AuthEvent{
  const SyncRemoteToLocal();

  @override
  List<Object?> get props => [];
}class SyncLocalToRemote extends AuthEvent{
  const SyncLocalToRemote();

  @override
  List<Object?> get props => [];
}
class RemoveLocal extends AuthEvent{
  const RemoveLocal();

  @override
  List<Object?> get props => [];
}
class AuthPass extends AuthEvent{
  const AuthPass();

  @override
  List<Object?> get props => [];
}

class SwitchAuthEvent extends AuthEvent{
  const SwitchAuthEvent();

  @override
  List<Object?> get props => [];
}
