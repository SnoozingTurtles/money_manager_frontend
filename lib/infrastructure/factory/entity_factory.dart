import 'package:money_manager/domain/factory/IEntityFactory.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/models/user_model.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

class EntityFactory extends IEntityFactory {
  @override
  Expense newExpense(
      {required Amount amount,
      Note? note,
      required Category category,
      required DateTime dateTime,
      required bool recurring,
      required String medium}) {
    return Expense(
        amount: amount, category: category, dateTime: dateTime, note: note, recurring: recurring, medium: medium);
  }

  @override
  Income newIncome(
      {required Amount amount,
      Note? note,
      required Category category,
      required DateTime dateTime,
      required bool recurring}) {
    return Income(amount: amount,note: note, category: category, dateTime: dateTime, recurring: recurring);
  }

  @override
  User newUser({required UserId uid,required double balance,required double expense, required double income}) {
    return User(userId: uid,balance: balance,expense:expense,income:income);
  }
}
