import 'package:dartz/dartz.dart';
import 'package:money_manager/application/boundaries/add_transaction/i_add_transaction_usecase.dart';
import 'package:money_manager/application/boundaries/add_transaction/add_transaction_input.dart';
import 'package:money_manager/application/boundaries/add_transaction/add_transaction_output.dart';
import 'package:money_manager/domain/factory/i_entity_factory.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/repositories/i_transaction_repository.dart';
import 'package:money_manager/domain/value_objects/value_failure.dart';

import '../../domain/value_objects/user/value_objects.dart';

class AddTransactionUseCase implements IAddTransactionUseCase {
  final ITransactionRepository _transactionRepository;
  final IEntityFactory _entityFactory;

  const AddTransactionUseCase(
      {required ITransactionRepository transactionRepository, required IEntityFactory entityFactory})
      : _entityFactory = entityFactory,
        _transactionRepository = transactionRepository;

  @override
  Future<Either<Failure, AddTransactionOutput>> execute({required AddTransactionInput input, UserId? remoteId}) async {
    Transaction newTransaction = _createTransactionFromInput(input);
    await _transactionRepository.add(transaction: newTransaction, localId: input.id, remoteId: remoteId);
    return _buildOutputFromNewTransaction(newTransaction);
  }

  Transaction _createTransactionFromInput(AddTransactionInput input) {
    if (input is AddExpenseInput) {
      return _entityFactory.newExpense(
          localId: input.id,
          amount: input.amount,
          category: input.category,
          dateTime: input.dateTime,
          note: input.note,
          recurring: input.recurring,
          medium: "Cash");
    } else {
      return _entityFactory.newIncome(
          localId: input.id,
          amount: input.amount,
          category: input.category,
          dateTime: input.dateTime,
          recurring: input.recurring,
          note: input.note);
    }
  }

  Either<Failure, AddTransactionOutput> _buildOutputFromNewTransaction(Transaction input) {
    AddTransactionOutput output;
    if (input is Expense) {
      output = AddExpenseOutput(
          amount: input.amount,
          category: input.category,
          dateTime: input.dateTime,
          note: input.note,
          recurring: input.recurring,
          medium: "Cash");
    } else {
      output = AddIncomeOutput(
        amount: input.amount,
        category: input.category,
        dateTime: input.dateTime,
        note: input.note,
        recurring: input.recurring,
      );
    }
    return Right(output);
  }
}
