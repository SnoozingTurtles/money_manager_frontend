part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserNotLoaded extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded({required this.user});
  @override
  List<Object> get props => [user];

  UserLoaded copyWith({User? user}) {
    return UserLoaded(
      user: user ?? this.user,
    );
  }
}
