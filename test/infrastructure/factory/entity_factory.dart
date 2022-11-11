import 'package:flutter_test/flutter_test.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';
import 'package:money_manager/infrastructure/factory/entity_factory.dart';

void main(){
  EntityFactory sut = EntityFactory();

  test('should create a transaction from provided information',(){
    //arrange
    var amount = Amount("24");
    var category = Category("category");
    var note = Note("note");
    var dateTime = DateTime.now();

    //act
    var transaction = sut.newExpense(
      amount:amount,
      category:category,
      note:note,
      dateTime:dateTime,
      recurring: false,
      medium:"cash",
    );

    //assert
    expect(transaction.amount.value,amount.value);
  });
}