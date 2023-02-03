import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:money_manager/application/boundaries/add_transaction/add_transaction_input.dart';
import 'package:money_manager/application/usecases/add_transaction_usecase.dart';
import 'package:money_manager/domain/factory/i_entity_factory.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/repositories/i_transaction_repository.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<ITransactionRepository>(as: #MockTransactionRepository),MockSpec<IEntityFactory>(as: #MockEntityFactory),MockSpec<Expense>(as: #MockExpense)])
import 'add_transaction_usecase_test.mocks.dart';
void main() {
  var mockTransactionRepository = MockTransactionRepository();
  var mockEntityFactory = MockEntityFactory();

  AddTransactionUseCase sut = AddTransactionUseCase(
    transactionRepository: mockTransactionRepository,
    entityFactory: mockEntityFactory,
  );

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    mockEntityFactory = MockEntityFactory();

    sut = AddTransactionUseCase(
      transactionRepository: mockTransactionRepository,
      entityFactory: mockEntityFactory,
    );
  });

  group("Add Transaction Use Case", () {
    var amount = Amount("24");
    var category = Category("value");
    var note = Note("value");
    var dateTime = DateTime.now();

    var input = AddExpenseInput(
      id:UserId(1),
      amount: amount,
      category: category,
      note: note,
      dateTime: dateTime,
      recurring: false,
      medium: "cash",
    );

    test('should return transaction with created id when added successfully',
        () async {
      //arrange
      when(mockEntityFactory.newExpense(
        amount: anyNamed('amount'),
        category: anyNamed('category'),
        note: anyNamed('note'),
        dateTime: anyNamed('dateTime'),
        recurring: anyNamed('recurring'),
        medium: anyNamed('medium'),
      )).thenReturn(Expense(
        amount: input.amount,
        medium: input.medium,
        recurring: input.recurring,
        dateTime: input.dateTime,
        category: input.category,
        note: input.note,
      ));

      //act
      var result = await sut.execute(input);

      //assert
      expect(result.isRight(), true);
      // expect(result.getOrElse(null).tId, isNotNull);
      verify(mockTransactionRepository.add(any,any)).called(1);
    });
  });
}
