import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';
import 'package:money_manager/infrastructure/datasource/IDatasource.dart';
import 'package:money_manager/infrastructure/model/model.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';

@GenerateNiceMocks([MockSpec<IDatasource>(as:#MockDataSource)])
import 'transaction_repository_test.mocks.dart';
void main() {
  MockDataSource mockDatasource = MockDataSource();

  TransactionRepository sut = TransactionRepository(datasource: mockDatasource);

  group('TransactionRepository.add', () {
    //arrange
    var amount = Amount("24");
    var category = Category("category");
    var note = Note("note");
    var dateTime = DateTime.now();

    var expense = Expense(
        amount: amount,
        category: category,
        dateTime: dateTime,
        recurring: false,
        medium: "medium");

    test('should add a transaction when call to the datasource is succesfull',
        () async {
      //act
      await sut.add(expense);
      //assert
      verify(mockDatasource.addTransaction(any)).called(1);
    });
  });

  group('TransactionRepository.getAll()', () {
    test(
        'should return a list of transactions when the call to the datasource is successful',
        () async {
      //arrange
      var map = {
        "amount": "2",
        "category": "food",
        "dateTime": DateTime.now().toIso8601String(),
        "note": "note",
        "recurring": "false",
        "medium": "cash",
      };
      when(mockDatasource.get())
          .thenAnswer((_) async => [ExpenseModel.fromMap(map)]);

      //act
      var transaction = await sut.get();

      //assert
      expect(transaction, isNotEmpty);
      verify(mockDatasource.get()).called(1);
    });
  });
}
