import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:money_manager/application/usecases/get_transaction_usecase.dart';

import 'add_transaction_usecase_test.mocks.dart';

void main() {
  var mockTransactionRepository = MockTransactionRepository();

  GetAllTransactionUseCase getAllTransactionUseCase = GetAllTransactionUseCase(
      iTransactionRepository: mockTransactionRepository);

  group('GetAllBooksUseCase', () {
    test('should get empty list when no transactions are found', () async {
      //arrange
      when(mockTransactionRepository.get()).thenAnswer((_) async=> []);

      //act
      var result = await getAllTransactionUseCase.execute();

      //assert
      expect(result.transactions, isEmpty);
    });
  });

  test('should return list of transactions', () async {
    //arrange
    var transactions = [MockExpense()];
    when(mockTransactionRepository.get())
        .thenAnswer((realInvocation) async=> transactions);

    //act
    var result = await getAllTransactionUseCase.execute();

    //assert
    expect(result.transactions, isNotEmpty);
  });
}
