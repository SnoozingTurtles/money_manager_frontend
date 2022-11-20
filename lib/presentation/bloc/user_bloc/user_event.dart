part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class InitUser extends UserEvent{
  @override
  // TODO: implement props
  List<Object?> get props =>[];

}
class LoadUser extends UserEvent{
  @override
  // TODO: implement props
  List<Object?> get props =>[];

}

class ReloadUser extends UserEvent{
  final double balance;
  final double income;
  final double expense;
  const ReloadUser({required this.balance,required this.income,required this.expense});
  @override
  // TODO: implement props
  List<Object?> get props =>[balance,income,expense];

}

