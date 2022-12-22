import 'package:equatable/equatable.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

import '../value_objects/user/value_objects.dart';

class User extends Equatable {
  final UserId userId;
  final double balance;
  final double expense;
  final double income;
  final bool loggedIn;
  final UserId? remoteId;
  final Email? email;
  final String? token;

  const User(
      {required this.userId,
      required this.balance,
      required this.expense,
      required this.income,
      required this.loggedIn,
      this.email,
      this.token,
      this.remoteId});

  @override
  List<Object?> get props => [userId, balance, expense, income, loggedIn];

  User copyWith({Email?email,double? balance, String? token, double? income, double? expense, bool? loggedIn, UserId? remoteId}) {
    return User(
        token: token ?? this.token,
        userId: userId,
        email:email??this.email,
        balance: balance ?? this.balance,
        income: income ?? this.income,
        expense: expense ?? this.expense,
        loggedIn: loggedIn ?? this.loggedIn,
        remoteId: remoteId ?? this.remoteId);
  }
}
