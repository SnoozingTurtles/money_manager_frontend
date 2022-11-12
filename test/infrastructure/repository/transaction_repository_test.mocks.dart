// Mocks generated by Mockito 5.3.2 from annotations
// in money_manager/test/infrastructure/repository/transaction_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:money_manager/infrastructure/datasource/IDatasource.dart'
    as _i2;
import 'package:money_manager/infrastructure/model/model.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [IDatasource].
///
/// See the documentation for Mockito's code generation for more information.
class MockDataSource extends _i1.Mock implements _i2.IDatasource {
  @override
  _i3.Future<void> addTransaction(_i4.TransactionModel? model) =>
      (super.noSuchMethod(
        Invocation.method(
          #addTransaction,
          [model],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> addExpense(_i4.ExpenseModel? expense) => (super.noSuchMethod(
        Invocation.method(
          #addExpense,
          [expense],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> addIncome(_i4.IncomeModel? income) => (super.noSuchMethod(
        Invocation.method(
          #addIncome,
          [income],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<List<_i4.TransactionModel>> get() => (super.noSuchMethod(
        Invocation.method(
          #get,
          [],
        ),
        returnValue: _i3.Future<List<_i4.TransactionModel>>.value(
            <_i4.TransactionModel>[]),
        returnValueForMissingStub: _i3.Future<List<_i4.TransactionModel>>.value(
            <_i4.TransactionModel>[]),
      ) as _i3.Future<List<_i4.TransactionModel>>);
}