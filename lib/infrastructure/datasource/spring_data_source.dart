import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:money_manager/common/diox.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/infrastructure/datasource/i_data_source.dart';
import 'package:http_parser/http_parser.dart';
import '../../domain/value_objects/user/value_objects.dart';

//only token usage in application is here get rid of token every where else ...
class SpringBootDataSource implements IDatasource {
  @override
  Future<void> addExpense({required Expense expense, UserId? remoteId}) async {
    Api _xdio = Api();
    Map<String, dynamic> map = expense.toSpringMap();
    await _xdio.api.post(
      'http://127.0.0.1:8080/api/user/${remoteId!.value}/expenses',
      options: Options(extra: map),
      data: FormData.fromMap(
        {
          'expense': MultipartFile.fromString(
            jsonEncode(map),
            contentType: MediaType.parse('application/json'),
          ),
        },
      ),
    );
  }

  @override
  Future<void> addIncome({required Income income, UserId? remoteId}) async {
    Api _xdio = Api();
    Map<String, dynamic> map = income.toSpringMap();

    await _xdio.api.post(
      'http://127.0.0.1:8080/api/user/${remoteId!.value}/incomes',
      options: Options(extra: map),
      data: FormData.fromMap(
        {
          'income': MultipartFile.fromString(
            jsonEncode(map),
            contentType: MediaType.parse('application/json'),
          ),
        },
      ),
    );
  }

  @override
  Future<void> addTransaction({required Transaction model, UserId? remoteId}) async {
    if (model is Expense) {
      debugPrint("ERROR CHECK REMOTEID IS CAUSEING IT $remoteId");
      await addExpense(expense: model, remoteId: remoteId);
    } else if (model is Income) {
      await addIncome(income: model, remoteId: remoteId);
    }
  }

  @override
  Future<List<Transaction>> get({required String startDate, required String endDate, UserId? remoteId}) async {
    var map1 = await getIncome(startDate: startDate, endDate: endDate, remoteId: remoteId);
    var map2 = await getExpense(startDate: startDate, endDate: endDate, remoteId: remoteId);
    List<Transaction> listOfMaps = [...map2, ...map1];
    if (listOfMaps.isEmpty) return [];

    return listOfMaps;
  }

  @override
  Future<List<Expense>> getExpense({required String startDate, required String endDate, UserId? remoteId}) async {
    Api _xdio = Api();

    var mapExpense = await _xdio.api.get('http://127.0.0.1:8080/api/user/${remoteId!.value}/expenses');

    debugPrint('SPRING DATA SOURCE:65: getIncome: $mapExpense');
    List map1 = [];
    try {
      map1 = mapExpense.data["dtoData"];
    } catch (e) {
      debugPrint(e.toString());
    }
    return map1.map((expense) => Expense.fromSpringMap(expense)).toList();
  }

  @override
  Future<List<Income>> getIncome({required String startDate, required String endDate, UserId? remoteId}) async {
    Api _xdio = Api();
    var mapIncome = await _xdio.api.get('http://127.0.0.1:8080/api/user/${remoteId!.value}/incomes');
    debugPrint('SPRING DATA SOURCE:65: getIncome: $mapIncome');
    List map1 = [];
    try {
      map1 = mapIncome.data["dtoData"];
    } catch (e) {
      debugPrint(e.toString());
    }
    return map1.map((income) => Income.fromSpringMap(income)).toList();
  }

  Future<void> addFromLocalBuffer({required List<Map<String, Object?>> transactions, UserId? remoteId}) async {
    Api _xdio = Api();
    for (var transaction in transactions) {
      Map<String, dynamic> map = {};
      if ((transaction['transactionType'] as String) == 'expense') {
        map = {
          "amount": transaction['amount'],
          "category": transaction['category'],
          "dateAdded": transaction['dateTime'],
          "description": transaction['note'],
          "type": transaction['medium'],
        };
        await _xdio.api.post('http://127.0.0.1:8080/api/user/${remoteId!.value}/expenses',
            data: FormData.fromMap(
              {
                'expense': MultipartFile.fromString(
                  jsonEncode(map),
                  contentType: MediaType.parse('application/json'),
                )
              },
            ),
            options: Options(extra: map));
      } else {
        map = {
          "amount": transaction['amount'],
          "category": transaction['category'],
          "dateAdded": transaction['dateTime'],
          "description": transaction['note'],
        };
        await _xdio.api.post(
          'http://127.0.0.1:8080/api/user/${remoteId!.value}/incomes',
          data: FormData.fromMap(
            {
              'income': MultipartFile.fromString(
                jsonEncode(map),
                contentType: MediaType.parse('application/json'),
              )
            },
          ),
        );
      }
    }
  }
}
