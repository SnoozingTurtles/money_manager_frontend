import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/models/user_model.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

import '../value_objects/user/value_objects.dart';

abstract class IEntityFactory {
  Income newIncome(
      {required UserId localId,
      required Amount amount,
      Note? note,
      required Category category,
      required DateTime dateTime,
      required bool recurring});

  Expense newExpense({
    required UserId localId,
    required Amount amount,
    Note? note,
    required Category category,
    required DateTime dateTime,
    required bool recurring,
    required String medium,
  });

  User newUser({
    required UserId localId,
    required double balance,
    required double expense,
    required double income,
    required bool loggedIn,
    UserId? remoteId,
  });
}
