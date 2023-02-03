part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserNotLoaded extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  final UserId localId;
  final UserId? remoteId;
  final double balance;
  final double expense;
  final double income;
  final bool loggedIn;
  final bool firstRun;

  const UserLoaded({
    required this.localId,
    this.remoteId,
    required this.firstRun,
    required this.balance,
    required this.expense,
    required this.income,
    required this.loggedIn,
  });

  @override
  List<Object> get props => remoteId == null
      ? [firstRun, localId, balance, expense, income, loggedIn]
      : [firstRun, localId, balance, expense, income, loggedIn, remoteId!];

  UserLoaded copyWith(
      {Email? email,
      double? balance,
      String? token,
      double? income,
      double? expense,
      bool? loggedIn,
      UserId? remoteId,
      bool? firstRun}) {
    return UserLoaded(
      firstRun: firstRun ?? this.firstRun,
      localId: localId,
      remoteId: remoteId ?? this.remoteId,
      balance: balance ?? this.balance,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      loggedIn: loggedIn ?? this.loggedIn,
    );
  }
}
