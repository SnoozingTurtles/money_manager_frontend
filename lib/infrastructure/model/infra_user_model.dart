import 'package:money_manager/domain/value_objects/user/value_objects.dart';

class UserModel {
  UserId userId;
  double balance;
  double income;
  double expense;
  String? token;
  Email? email;
  bool loggedIn;
  UserModel(
      {required this.userId,
      required this.balance,
      required this.income,
      required this.expense,
      this.token,
      this.email,
      required this.loggedIn});
}
