import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/models/user_model.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

abstract class IEntityFactory {
  Income newIncome(
      {required Amount amount,
      Note? note,
      required Category category,
      required DateTime dateTime,
      required bool recurring});

  Expense newExpense({
    required Amount amount,
    Note? note,
    required Category category,
    required DateTime dateTime,
    required bool recurring,
    required String medium,
  });

  User newUser({
    required UserId uid,
    required double balance,
    required double expense,
    required double income,
  });
}
