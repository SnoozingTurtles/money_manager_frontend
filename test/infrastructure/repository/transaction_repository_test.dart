import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:money_manager/common/connectivity.dart';
import 'package:money_manager/infrastructure/datasource/sqlite_data_source.dart';
import 'package:money_manager/infrastructure/datasource/spring_data_source.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';
import 'package:sqflite/sqflite.dart';


@GenerateNiceMocks([MockSpec<Database>(as: #db)])
import 'transaction_repository_test.mocks.dart';

void main() {
  // MockDataSource mockDatasource = MockDataSource();
  db _db = db();
  TransactionRepository sut = TransactionRepository(
      localDatasource: SqliteDataSource(db:_db), remoteDatasource:SpringBootDataSource(), connectivity: ConnectivitySingleton.getInstance());

  // group('TransactionRepository.add', () {
  //   //arrange
  //   var amount = Amount("24");
  //   var category = Category("category");
  //   var note = Note("note");
  //   var dateTime = DateTime.now();
  //
  //   var expense = Expense(amount: amount, category: category, dateTime: dateTime, recurring: false, medium: "medium");
  //
  //   test('should add a transaction when call to the datasource is succesfull', () async {
  //     //act
  //     await sut.add(expense);
  //     //assert
  //     verify(mockDatasource.addTransaction(any)).called(1);
  //   });
  // });

  group('TransactionRepository.getAll()', () {
    test('should return a list of transactions when the call to the datasource is successful', () async {
      // when(mockDatasource.get()).thenAnswer((_) async => [ExpenseModel.fromMap(map), ExpenseModel.fromMap(map1)]);

      //act
      var transaction = await sut.getLocal();

      //assert
      expect(transaction, isNotEmpty);
    });
  });
}
