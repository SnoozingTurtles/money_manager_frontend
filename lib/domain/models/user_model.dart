import 'package:equatable/equatable.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

class User extends Equatable {
  final UserId userId;
  final double balance;
  final double expense;
  final double income;

  const User({required this.userId, required this.balance,required this.expense,required this.income});

  @override
  List<Object?> get props => [userId, balance];

  User copyWith({double? balance,double?income,double?expense}) {
    return User(userId: userId, balance: balance ?? this.balance,income:income??this.income,expense:expense??this.expense);
  }
}
