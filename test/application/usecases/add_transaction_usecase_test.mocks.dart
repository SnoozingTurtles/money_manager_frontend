// Mocks generated by Mockito 5.3.2 from annotations
// in money_manager/test/application/usecases/add_transaction_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:mockito/mockito.dart' as _i1;
import 'package:money_manager/domain/factory/i_entity_factory.dart' as _i7;
import 'package:money_manager/domain/models/transaction_model.dart' as _i2;
import 'package:money_manager/domain/models/user_model.dart' as _i3;
import 'package:money_manager/domain/repositories/i_transaction_repository.dart'
    as _i5;
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart'
    as _i4;

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

class _FakeIncome_0 extends _i1.SmartFake implements _i2.Income {
  _FakeIncome_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeExpense_1 extends _i1.SmartFake implements _i2.Expense {
  _FakeExpense_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUser_2 extends _i1.SmartFake implements _i3.User {
  _FakeUser_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAmount_3 extends _i1.SmartFake implements _i4.Amount {
  _FakeAmount_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCategory_4 extends _i1.SmartFake implements _i4.Category {
  _FakeCategory_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDateTime_5 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ITransactionRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockTransactionRepository extends _i1.Mock
    implements _i5.ITransactionRepository {
  @override
  _i6.Future<void> add(
    _i2.Transaction? transactions,
    _i4.UserId? id,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #add,
          [
            transactions,
            id,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<List<_i2.Transaction>> getLocal() => (super.noSuchMethod(
        Invocation.method(
          #getLocal,
          [],
        ),
        returnValue:
            _i6.Future<List<_i2.Transaction>>.value(<_i2.Transaction>[]),
        returnValueForMissingStub:
            _i6.Future<List<_i2.Transaction>>.value(<_i2.Transaction>[]),
      ) as _i6.Future<List<_i2.Transaction>>);
  @override
  _i6.Future<List<_i2.Transaction>> getRemote() => (super.noSuchMethod(
        Invocation.method(
          #getRemote,
          [],
        ),
        returnValue:
            _i6.Future<List<_i2.Transaction>>.value(<_i2.Transaction>[]),
        returnValueForMissingStub:
            _i6.Future<List<_i2.Transaction>>.value(<_i2.Transaction>[]),
      ) as _i6.Future<List<_i2.Transaction>>);
  @override
  _i6.Future<List<Map<String, Object?>>> getBuffer() => (super.noSuchMethod(
        Invocation.method(
          #getBuffer,
          [],
        ),
        returnValue: _i6.Future<List<Map<String, Object?>>>.value(
            <Map<String, Object?>>[]),
        returnValueForMissingStub: _i6.Future<List<Map<String, Object?>>>.value(
            <Map<String, Object?>>[]),
      ) as _i6.Future<List<Map<String, Object?>>>);
  @override
  _i6.Future<void> syncRemoteToLocal() => (super.noSuchMethod(
        Invocation.method(
          #syncRemoteToLocal,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  _i6.Future<void> syncLocalToRemote() => (super.noSuchMethod(
        Invocation.method(
          #syncLocalToRemote,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}

/// A class which mocks [IEntityFactory].
///
/// See the documentation for Mockito's code generation for more information.
class MockEntityFactory extends _i1.Mock implements _i7.IEntityFactory {
  @override
  _i2.Income newIncome({
    required _i4.Amount? amount,
    _i4.Note? note,
    required _i4.Category? category,
    required DateTime? dateTime,
    required bool? recurring,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #newIncome,
          [],
          {
            #amount: amount,
            #note: note,
            #category: category,
            #dateTime: dateTime,
            #recurring: recurring,
          },
        ),
        returnValue: _FakeIncome_0(
          this,
          Invocation.method(
            #newIncome,
            [],
            {
              #amount: amount,
              #note: note,
              #category: category,
              #dateTime: dateTime,
              #recurring: recurring,
            },
          ),
        ),
        returnValueForMissingStub: _FakeIncome_0(
          this,
          Invocation.method(
            #newIncome,
            [],
            {
              #amount: amount,
              #note: note,
              #category: category,
              #dateTime: dateTime,
              #recurring: recurring,
            },
          ),
        ),
      ) as _i2.Income);
  @override
  _i2.Expense newExpense({
    required _i4.Amount? amount,
    _i4.Note? note,
    required _i4.Category? category,
    required DateTime? dateTime,
    required bool? recurring,
    required String? medium,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #newExpense,
          [],
          {
            #amount: amount,
            #note: note,
            #category: category,
            #dateTime: dateTime,
            #recurring: recurring,
            #medium: medium,
          },
        ),
        returnValue: _FakeExpense_1(
          this,
          Invocation.method(
            #newExpense,
            [],
            {
              #amount: amount,
              #note: note,
              #category: category,
              #dateTime: dateTime,
              #recurring: recurring,
              #medium: medium,
            },
          ),
        ),
        returnValueForMissingStub: _FakeExpense_1(
          this,
          Invocation.method(
            #newExpense,
            [],
            {
              #amount: amount,
              #note: note,
              #category: category,
              #dateTime: dateTime,
              #recurring: recurring,
              #medium: medium,
            },
          ),
        ),
      ) as _i2.Expense);
  @override
  _i3.User newUser({
    required _i4.UserId? uid,
    required double? balance,
    required double? expense,
    required double? income,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #newUser,
          [],
          {
            #uid: uid,
            #balance: balance,
            #expense: expense,
            #income: income,
          },
        ),
        returnValue: _FakeUser_2(
          this,
          Invocation.method(
            #newUser,
            [],
            {
              #uid: uid,
              #balance: balance,
              #expense: expense,
              #income: income,
            },
          ),
        ),
        returnValueForMissingStub: _FakeUser_2(
          this,
          Invocation.method(
            #newUser,
            [],
            {
              #uid: uid,
              #balance: balance,
              #expense: expense,
              #income: income,
            },
          ),
        ),
      ) as _i3.User);
}

/// A class which mocks [Expense].
///
/// See the documentation for Mockito's code generation for more information.
class MockExpense extends _i1.Mock implements _i2.Expense {
  @override
  String get medium => (super.noSuchMethod(
        Invocation.getter(#medium),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
  @override
  set medium(String? _medium) => super.noSuchMethod(
        Invocation.setter(
          #medium,
          _medium,
        ),
        returnValueForMissingStub: null,
      );
  @override
  List<Object?> get props => (super.noSuchMethod(
        Invocation.getter(#props),
        returnValue: <Object?>[],
        returnValueForMissingStub: <Object?>[],
      ) as List<Object?>);
  @override
  _i4.Amount get amount => (super.noSuchMethod(
        Invocation.getter(#amount),
        returnValue: _FakeAmount_3(
          this,
          Invocation.getter(#amount),
        ),
        returnValueForMissingStub: _FakeAmount_3(
          this,
          Invocation.getter(#amount),
        ),
      ) as _i4.Amount);
  @override
  set amount(_i4.Amount? _amount) => super.noSuchMethod(
        Invocation.setter(
          #amount,
          _amount,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i4.Category get category => (super.noSuchMethod(
        Invocation.getter(#category),
        returnValue: _FakeCategory_4(
          this,
          Invocation.getter(#category),
        ),
        returnValueForMissingStub: _FakeCategory_4(
          this,
          Invocation.getter(#category),
        ),
      ) as _i4.Category);
  @override
  set category(_i4.Category? _category) => super.noSuchMethod(
        Invocation.setter(
          #category,
          _category,
        ),
        returnValueForMissingStub: null,
      );
  @override
  set note(_i4.Note? _note) => super.noSuchMethod(
        Invocation.setter(
          #note,
          _note,
        ),
        returnValueForMissingStub: null,
      );
  @override
  DateTime get dateTime => (super.noSuchMethod(
        Invocation.getter(#dateTime),
        returnValue: _FakeDateTime_5(
          this,
          Invocation.getter(#dateTime),
        ),
        returnValueForMissingStub: _FakeDateTime_5(
          this,
          Invocation.getter(#dateTime),
        ),
      ) as DateTime);
  @override
  set dateTime(DateTime? _dateTime) => super.noSuchMethod(
        Invocation.setter(
          #dateTime,
          _dateTime,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get recurring => (super.noSuchMethod(
        Invocation.getter(#recurring),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  set recurring(bool? _recurring) => super.noSuchMethod(
        Invocation.setter(
          #recurring,
          _recurring,
        ),
        returnValueForMissingStub: null,
      );
}
