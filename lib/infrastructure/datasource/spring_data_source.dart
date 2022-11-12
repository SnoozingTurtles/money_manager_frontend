import 'package:money_manager/infrastructure/datasource/IDatasource.dart';
import 'package:money_manager/infrastructure/model/model.dart';
import 'package:dio/dio.dart';

class SpringBootDataSource implements IDatasource{
  @override
  Future<void> addExpense(ExpenseModel expense)async {
    Dio dio = Dio();
    Map<String,dynamic> map = expense.toSpringMap();
    await dio.post("https://money-manager-snoozingturtle.herokuapp.com/api/user/1/expenses",data: map);
  }

  @override
  Future<void> addIncome(IncomeModel income)async {
    Dio dio = Dio();
    Map<String,dynamic> map = income.toMap();
    await dio.post("https://money-manager-snoozingturtle.herokuapp.com/api/user/1/expenses",data: map);
  }

  @override
  Future<void> addTransaction(TransactionModel model) async{
    if(model is ExpenseModel){
      await addExpense(model);
    }else if(model is IncomeModel){
      await addIncome(model);
    }
  }

  @override
  Future<List<TransactionModel>> get() async{
    Dio dio = Dio();
    var mapExpense = await dio.get("https://money-manager-snoozingturtle.herokuapp.com/api/user/1/expenses");
    var mapIncome = await dio.get("https://money-manager-snoozingturtle.herokuapp.com/api/user/1/incomes") ;

    var map1 = mapExpense.data;
    var map2 = mapIncome.data;
    
    var listOfMaps = [...map2, ...map1];
    if(listOfMaps.isEmpty) return [];

    return listOfMaps.map((transaction)=>ExpenseModel.fromSpringMap(transaction)).toList();
  }
  
}