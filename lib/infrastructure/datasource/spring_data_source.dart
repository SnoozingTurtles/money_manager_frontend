import 'package:flutter/foundation.dart';
import 'package:money_manager/common/constants.dart';
import 'package:money_manager/common/diox.dart';
import 'package:money_manager/infrastructure/datasource/i_data_source.dart';
import 'package:money_manager/infrastructure/model/infra_transaction_model.dart';


//only token usage in application is here get rid of token every where else ...
class SpringBootDataSource implements IDatasource {
  @override
  Future<void> addExpense(ExpenseModel expense) async {
    Api _xdio = Api();
    Map<String, dynamic> map = expense.toSpringMap();
    await _xdio.api.post(EXPENSE_ENDPOINT, data: map);
  }

  @override
  Future<void> addIncome(IncomeModel income) async {
    Api _xdio = Api();
    Map<String, dynamic> map = income.toSpringMap();

    await _xdio.api.post(INCOME_ENDPOINT, data: map);
  }

  @override
  Future<void> addTransaction(TransactionModel model) async {
    if (model is ExpenseModel) {
      await addExpense(model);
    } else if (model is IncomeModel) {
      await addIncome(model);
    }
  }

  @override
  Future<List<TransactionModel>> get(String startDate, String endDate) async {
    var map1 = await getIncome(startDate, endDate);
    var map2 = await getExpense(startDate, endDate);
    List<TransactionModel> listOfMaps = [...map2, ...map1];
    if (listOfMaps.isEmpty) return [];

    return listOfMaps;
  }

  @override
  Future<List<ExpenseModel>> getExpense(String startDate, String endDate) async {
    Api _xdio = Api();

    var mapExpense = await _xdio.api.get(EXPENSE_ENDPOINT);

    List map1 = [];
    try {
      map1 = mapExpense.data["dtoData"];
    } catch (e) {
      debugPrint(e.toString());
    }
    return map1.map((expense) => ExpenseModel.fromSpringMap(expense)).toList();
  }

  @override
  Future<List<IncomeModel>> getIncome(String startDate, String endDate) async {
    Api _xdio = Api();
    var mapIncome = await _xdio.api.get(INCOME_ENDPOINT);
    List map1 = [];
    try {
      map1 = mapIncome.data["dtoData"];
    } catch (e) {
      debugPrint(e.toString());
    }
    return map1.map((income) => IncomeModel.fromSpringMap(income)).toList();
  }

  Future<void> addFromLocalBuffer(List<Map<String, Object?>> transactions) async {
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
        await _xdio.api.post(EXPENSE_ENDPOINT, data: map);
      } else {
        map = {
          "amount": transaction['amount'],
          "category": transaction['category'],
          "dateAdded": transaction['dateTime'],
          "description": transaction['note'],
        };
        await _xdio.api.post(INCOME_ENDPOINT, data: map);
      }
    }
  }
}
