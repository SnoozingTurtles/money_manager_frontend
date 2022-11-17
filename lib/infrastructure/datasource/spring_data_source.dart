import 'package:flutter/foundation.dart';
import 'package:money_manager/infrastructure/datasource/IDatasource.dart';
import 'package:money_manager/infrastructure/model/model.dart';
import 'package:dio/dio.dart';

class SpringBootDataSource implements IDatasource {
  @override
  Future<void> addExpense(ExpenseModel expense) async {
    Dio dio = Dio();
    Map<String, dynamic> map = expense.toSpringMap();
    await dio.post("https://money-manager-snoozingturtle.herokuapp.com/api/user/1/expenses", data: map);
  }

  @override
  Future<void> addIncome(IncomeModel income) async {
    Dio dio = Dio();
    Map<String, dynamic> map = income.toMap();
    await dio.post("https://money-manager-snoozingturtle.herokuapp.com/api/user/1/expenses", data: map);
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
  Future<List<TransactionModel>> get() async {
    Dio dio = Dio();
    var map1 = await getIncome();
    var map2 = await getExpense();
    List<TransactionModel> listOfMaps = [...map2, ...map1];
    if (listOfMaps.isEmpty) return [];

    return listOfMaps;
  }
  @override
  Future<List<ExpenseModel>> getExpense() async{
    Dio dio = Dio();
    var mapExpense = await dio.get(
        "https://money-manager-snoozingturtle.herokuapp.com/api/user/1/expenses?pageSize=8&sortBy=dateAdded&sortOrder=DESC");

    List map1 = [];
    try{
      map1 = mapExpense.data["expenses"];
    }catch(e){
      debugPrint(e.toString());
    }
    return map1.map((expense) => ExpenseModel.fromSpringMap(expense)).toList();
  }
  @override
  Future<List<IncomeModel>> getIncome()async{
    Dio dio = Dio();
    var mapExpense = await dio.get(
        "https://money-manager-snoozingturtle.herokuapp.com/api/user/1/incomes?pageSize=8&sortBy=dateAdded&sortOrder=DESC");

    List map1 = [];
    try{
      map1 = mapExpense.data["expenses"];
    }catch(e){
      debugPrint(e.toString());
    }
    return map1.map((expense) => IncomeModel.fromSpringMap(expense)).toList();
  }

  Future<void> addFromLocalBuffer(List<Map<String, Object?>> transactions) async {
    Dio dio = Dio();

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
        await dio.post("https://money-manager-snoozingturtle.herokuapp.com/api/user/1/expenses", data: map);
      } else {
        map = {
          "amount": transaction['amount'],
          "category": transaction['category'],
          "dateAdded": transaction['dateTime'],
          "description": transaction['note'],
        };
      }
    }
  }

}
