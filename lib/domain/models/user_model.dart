import 'package:equatable/equatable.dart';

import '../value_objects/user/value_objects.dart';

class User extends Equatable {
  final UserId localId;
  final UserId? remoteId;
  final double balance;
  final double expense;
  final double income;
  final bool loggedIn;

  const User({
    required this.localId,
    this.remoteId,
    required this.balance,
    required this.expense,
    required this.income,
    required this.loggedIn,
  });

  @override
  List<Object?> get props => remoteId == null
      ? [localId, balance, expense, income, loggedIn]
      : [localId, balance, expense, income, loggedIn, remoteId];

  User copyWith(
      {Email? email,
      double? balance,
      String? token,
      double? income,
      double? expense,
      bool? loggedIn,
      UserId? remoteId}) {
    return User(
      localId: localId,
      remoteId: remoteId ?? this.remoteId,
      balance: balance ?? this.balance,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      loggedIn: loggedIn ?? this.loggedIn,
    );
  }
}
