import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:money_manager/common/secure_storage.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/repositories/i_transaction_repository.dart';
import 'package:money_manager/infrastructure/datasource/spring_data_source.dart';
import 'package:money_manager/infrastructure/datasource/sqlite_data_source.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../../domain/value_objects/user/value_objects.dart';

class TransactionRepository implements ITransactionRepository {
  final SqliteDataSource _localDatasource;
  final SpringBootDataSource _remoteDatasource;
  final InternetConnectionChecker _connectivity = InternetConnectionChecker();
  final SecureStorage _secureStorage = SecureStorage();

  TransactionRepository({required sql.Database db})
      : _localDatasource = SqliteDataSource(db: db),
        _remoteDatasource = SpringBootDataSource();

  @override
  Future<void> add({required Transaction transaction, required UserId localId, UserId? remoteId}) async {
    //create DTO model for infra layer from incoming transaction.
    Transaction model;
    if (transaction is Expense) {
      model = Expense(
          localId: localId,
          amount: transaction.amount,
          category: transaction.category,
          dateTime: transaction.dateTime,
          recurring: transaction.recurring,
          note: transaction.note,
          medium: transaction.medium);
    } else {
      model = Income(
        localId: localId,
        amount: transaction.amount,
        category: transaction.category,
        dateTime: transaction.dateTime,
        recurring: transaction.recurring,
        note: transaction.note,
      );
    }
    //connectivity
    await _localDatasource.addTransaction(model: model);

    if (await _secureStorage.hasToken()) {
      if (await _connectivity.hasConnection) {
        debugPrint("TRANSACTION REPO:54:addT:hasToken and hasConnection");
        await _remoteDatasource.addTransaction(model: model, remoteId: remoteId).onError((error, stackTrace) async {
          debugPrint('TRANSACTION REPO:64:addT:$error');
          await _localDatasource.addBuffer(model);
        });
      } else {
        await _localDatasource.addBuffer(model);
      }
    } else {
      await _localDatasource.addBuffer(model);
    }
  }

  @override
  Future<List<Transaction>> getLocal({required String startDate, required String endDate, UserId? id}) async {
    var transactions = await _localDatasource.get(startDate: startDate, endDate: endDate);
    return transactions.map((e) => e is Expense ? e.toDExpense() : (e as Income).toDIncome()).toList();
  }

  @override
  Future<List<Transaction>> getRemote({required String startDate, required String endDate, UserId? id}) async {
    var transactions = await _remoteDatasource.get(startDate: startDate, endDate: endDate, remoteId: id);
    return transactions.map((e) => e is Expense ? e.toDExpense() : (e as Income).toDIncome()).toList();
  }

  @override
  Future<List<Map<String, Object?>>> getBuffer() async {
    return await _localDatasource.getBuffer();
  }

  @override
  Future<void> syncRemoteToLocal({UserId? remoteId}) async {
    var startDate = DateTime.now().subtract(const Duration(days: 365));
    var endDate = DateTime.now();
    var map = await _remoteDatasource.get(
        startDate: startDate.toIso8601String(), endDate: endDate.toIso8601String(), remoteId: remoteId);
    // await _localDatasource.cleanDB();
    if (map.isNotEmpty) {
      for (var element in map) {
        await _localDatasource.addTransaction(model: element);
      }
    }
  }

  @override
  Future<void> syncLocalToRemote({UserId? remoteId}) async {
    if (await _connectivity.hasConnection) {
      var map = await getBuffer();
      debugPrint("SYNC LOCAL TO REMOTE EMPTY BUFFER IS : $map");
      try {
        await _remoteDatasource.addFromLocalBuffer(transactions: map, remoteId: remoteId);
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
