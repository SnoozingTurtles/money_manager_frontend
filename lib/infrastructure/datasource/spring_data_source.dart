import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:money_manager/common/constants.dart';
import 'package:money_manager/common/diox.dart';
import 'package:money_manager/infrastructure/datasource/i_data_source.dart';
import 'package:money_manager/infrastructure/model/infra_transaction_model.dart';
import 'package:http_parser/http_parser.dart';
import '../../domain/value_objects/user/value_objects.dart';

//only token usage in application is here get rid of token every where else ...
class SpringBootDataSource implements IDatasource {
  @override
  Future<void> addExpense({required ExpenseModel expense, UserId? remoteId}) async {
    Api _xdio = Api();
    Map<String, dynamic> map = expense.toSpringMap();
    await _xdio.api.post('http://192.168.0.100:8080/api/user/${remoteId!.value}/expenses',
        data: FormData.fromMap(
            {'expense': MultipartFile.fromString(jsonEncode(map), contentType: MediaType.parse('application/json'))}));
  }

  @override
  Future<void> addIncome({required IncomeModel income, UserId? remoteId}) async {
    Api _xdio = Api();
    Map<String, dynamic> map = income.toSpringMap();

    await _xdio.api.post('http://192.168.0.100:8080/api/user/${remoteId!.value}/incomes',
        data: FormData.fromMap(
            {'income': MultipartFile.fromString(jsonEncode(map), contentType: MediaType.parse('application/json'))}));
  }

  @override
  Future<void> addTransaction({required TransactionModel model, UserId? remoteId}) async {
    if (model is ExpenseModel) {
      await addExpense(expense: model, remoteId: remoteId);
    } else if (model is IncomeModel) {
      await addIncome(income: model, remoteId: remoteId);
    }
  }

  @override
  Future<List<TransactionModel>> get({required String startDate, required String endDate, UserId? remoteId}) async {
    var map1 = await getIncome(startDate: startDate, endDate: endDate, remoteId: remoteId);
    var map2 = await getExpense(startDate: startDate, endDate: endDate, remoteId: remoteId);
    List<TransactionModel> listOfMaps = [...map2, ...map1];
    if (listOfMaps.isEmpty) return [];

    return listOfMaps;
  }

  @override
  Future<List<ExpenseModel>> getExpense({required String startDate, required String endDate, UserId? remoteId}) async {
    Api _xdio = Api();

    var mapExpense = await _xdio.api.get('http://192.168.0.100:8080/api/user/${remoteId!.value}/expenses');

    debugPrint('SPRING DATA SOURCE:65: getIncome: $mapExpense');
    List map1 = [];
    try {
      map1 = mapExpense.data["dtoData"];
    } catch (e) {
      debugPrint(e.toString());
    }
    return map1.map((expense) => ExpenseModel.fromSpringMap(expense)).toList();
  }

  @override
  Future<List<IncomeModel>> getIncome({required String startDate, required String endDate, UserId? remoteId}) async {
    Api _xdio = Api();
    var mapIncome = await _xdio.api.get('http://192.168.0.100:8080/api/user/${remoteId!.value}/incomes');
    debugPrint('SPRING DATA SOURCE:65: getIncome: $mapIncome');
    List map1 = [];
    try {
      map1 = mapIncome.data["dtoData"];
    } catch (e) {
      debugPrint(e.toString());
    }
    return map1.map((income) => IncomeModel.fromSpringMap(income)).toList();
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
        await _xdio.api.post('http://192.168.0.100:8080/api/user/${remoteId!.value}/expenses',
            data: FormData.fromMap({
              'expense': MultipartFile.fromString(
                jsonEncode(map),
                contentType: MediaType.parse('application/json'),
              )
            }));
      } else {
        map = {
          "amount": transaction['amount'],
          "category": transaction['category'],
          "dateAdded": transaction['dateTime'],
          "description": transaction['note'],
        };
        await _xdio.api.post('http://192.168.0.100:8080/api/user/${remoteId!.value}/incomes',
            data: FormData.fromMap({
              'income': MultipartFile.fromString(
                jsonEncode(map),
                contentType: MediaType.parse('application/json'),
              )
            }));
      }
    }
  }
}
