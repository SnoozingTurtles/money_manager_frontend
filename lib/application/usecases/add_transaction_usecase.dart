import 'package:dartz/dartz.dart';
import 'package:money_manager/application/boundaries/add_transaction/IAddTransactionUseCase.dart';
import 'package:money_manager/application/boundaries/add_transaction/add_transaction_input.dart';
import 'package:money_manager/application/boundaries/add_transaction/add_transaction_output.dart';
import 'package:money_manager/domain/factory/IEntityFactory.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/repositories/ITransactionRepository.dart';
import 'package:money_manager/domain/value_objects/value_failure.dart';

class AddTransactionUseCase implements IAddTransactionUseCase {
  final ITransactionRepository _transactionRepository;
  final IEntityFactory _entityFactory;

  const AddTransactionUseCase(
      {required ITransactionRepository transactionRepository, required IEntityFactory entityFactory})
      : _entityFactory = entityFactory,
        _transactionRepository = transactionRepository;

  @override
  Future<Either<Failure, AddTransactionOutput>> execute(AddTransactionInput input) async {
    Transaction newTransaction = _createTransactionFromInput(input);
    await _transactionRepository.add(newTransaction, input.id);
    return _buildOutputFromNewTransaction(newTransaction);
  }

  Transaction _createTransactionFromInput(AddTransactionInput input) {
    if (input is AddExpenseInput) {
      return _entityFactory.newExpense(
          amount: input.amount,
          category: input.category,
          dateTime: input.dateTime,
          note: input.note,
          recurring: input.recurring,
          medium: "Cash");
    } else {
      return _entityFactory.newIncome(
          amount: input.amount,
          category: input.category,
          dateTime: input.dateTime,
          recurring: input.recurring,
          note: input.note);
    }
  }

  Either<Failure, AddTransactionOutput> _buildOutputFromNewTransaction(Transaction input) {
    AddTransactionOutput output;
    if(input is Expense) {
       output = AddExpenseOutput(
        amount: input.amount,
        category: input.category,
        dateTime: input.dateTime,
        note:input.note,
        recurring: input.recurring,
        medium: "Cash");
    }else{
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
