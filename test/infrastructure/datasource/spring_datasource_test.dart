import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';
import 'package:money_manager/infrastructure/datasource/spring_data_source.dart';
import 'package:money_manager/infrastructure/model/model.dart';

void main(){
  SpringBootDataSource sut = SpringBootDataSource();

  group('spring.addTransaction()', () {
    test('should perform a database insert', () async {
      //arrange
      var map = {
        "amount": "40000",
        "category": "biryani",
        "dateTime": DateTime.now().toIso8601String(),
        "note": "note",
        "recurring": "true",
        "medium": "cash",
      };
      var expenseModel = ExpenseModel.fromMap(map);

      //act
      await sut.addExpense(expenseModel);

      //assert
      // expect(recieve.length,3);
    });
  });
  group('spring.get()', () {
    test('should perform api query and return all records', () async {
      //arrange

      //act
      var expenseModels = await sut.get();

      //assert
      expect(expenseModels, isNotEmpty);
      expect(expenseModels[1].amount,Amount("2"));
    });
  });
}
