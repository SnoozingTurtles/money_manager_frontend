import 'package:flutter/cupertino.dart';
import 'package:money_manager/common/connectivity.dart';
import 'package:money_manager/common/secure_storage.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/repositories/i_transaction_repository.dart';
import 'package:money_manager/infrastructure/datasource/spring_data_source.dart';
import 'package:money_manager/infrastructure/datasource/sqlite_data_source.dart';
import 'package:money_manager/infrastructure/model/infra_transaction_model.dart';

import '../../domain/value_objects/user/value_objects.dart';

class TransactionRepository implements ITransactionRepository {
  final SqliteDataSource _localDatasource;
  final SpringBootDataSource _remoteDatasource;
  final ConnectivitySingleton _connectivity;
  final SecureStorage _secureStorage;

  TransactionRepository(
      {required SqliteDataSource localDatasource,
      required SpringBootDataSource remoteDatasource,
        required SecureStorage secureStorage,
      required ConnectivitySingleton connectivity})
      : _localDatasource = localDatasource,
        _remoteDatasource = remoteDatasource,
        _secureStorage = secureStorage,
        _connectivity = connectivity;

  Stream<bool> get connectivityStream => _connectivity.connectionChange;

  void dispose() {
    _connectivity.dispose();
  }

  @override
  Future<void> add(Transaction transaction, UserId id) async {
    //create DTO model for infra layer from incoming transaction.
    TransactionModel model;
    if (transaction is Expense) {
      model = ExpenseModel(
          id: id,
          amount: transaction.amount,
          category: transaction.category,
          dateTime: transaction.dateTime,
          token: transaction.token,
          recurring: transaction.recurring,
          note: transaction.note,
          medium: transaction.medium);
    } else {
      model = IncomeModel(
        id: id,
        amount: transaction.amount,
        category: transaction.category,
        dateTime: transaction.dateTime,
        recurring: transaction.recurring,
        note: transaction.note,
      );
    }
    //connectivity
    await _localDatasource.addTransaction(model);

    if (await _secureStorage.hasToken()) {
      if (_connectivity.hasConnection) {
        await _remoteDatasource.addTransaction(model).onError((error, stackTrace) => _localDatasource.addBuffer(model));
      } else {
        await _localDatasource.addBuffer(model);
      }
    } else {
       await _localDatasource.addBuffer(model);
    }
  }

  @override
  Future<List<Transaction>> getLocal(String startDate, String endDate) async {
    var transactions = await _localDatasource.get(startDate, endDate);
    return transactions.map((e) => e is ExpenseModel ? e.toDExpense() : (e as IncomeModel).toDIncome()).toList();
  }

  @override
  Future<List<Transaction>> getRemote(String startDate, String endDate) async {
    var transactions = await _remoteDatasource.get(startDate, endDate);
    return transactions.map((e) => e is ExpenseModel ? e.toDExpense() : (e as IncomeModel).toDIncome()).toList();
  }

  @override
  Future<List<Map<String, Object?>>> getBuffer() async {
    return await _localDatasource.getBuffer();
  }

  @override
  Future<void> syncRemoteToLocal() async {
    var startDate = DateTime.now().subtract(const Duration(days: 365));
    var endDate = DateTime.now();
    var map = await _remoteDatasource.get(startDate.toIso8601String(), endDate.toIso8601String());
    // await _localDatasource.cleanDB();
    if (map.isNotEmpty) {
      for (var element in map) {
        await _localDatasource.addTransaction(element);
      }
    }
  }

  @override
  Future<void> syncLocalToRemote() async {
    if (_connectivity.hasConnection) {
      var map = await getBuffer();
      print("SYNC LOCAL TO REMOTE EMPTY BUFFER IS : $map");
      try {
        await _remoteDatasource.addFromLocalBuffer(map);
      } catch (e) {
        debugPrint('SYNC LOCAL TO REMOTE ERROR: $e');
        return;
      }
      await _localDatasource.clearBuffer();
    } else {
      return;
    }
  }

  Future<void> clearDB() async {
    await _localDatasource.cleanDB();
  }
}
