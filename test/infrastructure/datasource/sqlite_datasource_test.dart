import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_manager/infrastructure/datasource/sqlite_data_source.dart';
import 'package:money_manager/infrastructure/model/model.dart';
import 'package:sqflite/sqflite.dart';

@GenerateNiceMocks([MockSpec<Database>(as: #MockDatabase)])
import 'sqlite_datasource_test.mocks.dart';

void main() {
  MockDatabase db = MockDatabase();
  SqliteDataSource sut = SqliteDataSource(db: db);

  var map = {
    "amount": "2",
    "category": "food",
    "dateTime": DateTime.now().toIso8601String(),
    "note": "note",
    "recurring": "false",
    "medium": "cash",
  };

  group('Sqlite.addTransaction()', () {
    test('should perform a database insert', () async {
      //arrange
      var expenseModel = ExpenseModel.fromMap(map);
      when(
        db.insert('expense', expenseModel.toMap(),),
      ).thenAnswer((_) async=> 1);

      //act
      await sut.addExpense(expenseModel);
      //assert
      verify(db.insert('expense', expenseModel.toMap(),))
          .called(1);
    });
  });

  group('sqlite.get()', () {
    test('should perform database query and return all records', () async {
      //arrange
      when(db.query('expense')).thenAnswer((_) async => [map]);

      //act
      var expenseModels = await sut.get();

      //assert
      expect(expenseModels, isNotEmpty);
      verify(db.query('expense'));
    });
  });
}
