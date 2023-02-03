part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class InitUser extends UserEvent{
  @override
  List<Object?> get props =>[];
}

class ReloadUserBalance extends UserEvent{
  final double? balance;
  final double? income;
  final double? expense;
  const ReloadUserBalance({required this.balance,required this.income,required this.expense});
  @override
  // TODO: implement props
  List<Object?> get props =>[balance,income,expense];
}
class LogUserIn extends UserEvent{
  final UserId remoteId;
  const LogUserIn({required this.remoteId});
  @override
  // TODO: implement props
  List<Object?> get props =>[remoteId];
}


