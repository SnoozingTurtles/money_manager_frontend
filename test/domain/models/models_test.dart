import 'package:flutter_test/flutter_test.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

void main() {
  group("Transaction model", () {
    test("failure should be returned if any of its parameters return failure",
        () {
      //arrange
      Expense expense = Expense(
          amount: Amount("0"),
          category: Category("food"),
          dateTime: DateTime.now(),
          recurring: false,
          medium: "medium");

      //assert
      expect(expense.toString(), equals("Amount(Left(Instance of 'Failure'))"));
    });
  });
}
