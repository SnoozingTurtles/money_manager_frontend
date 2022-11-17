import 'package:money_manager/common/connectivity.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/repositories/ITransactionRepository.dart';
import 'package:money_manager/infrastructure/datasource/spring_data_source.dart';
import 'package:money_manager/infrastructure/datasource/sqlite_data_source.dart';
import 'package:money_manager/infrastructure/model/model.dart';

class TransactionRepository implements ITransactionRepository {
  final SqliteDataSource _localDatasource;
  final SpringBootDataSource _remoteDatasource;
  final ConnectivitySingleton _connectivity;
  TransactionRepository(
      {required SqliteDataSource localDatasource, required SpringBootDataSource remoteDatasource, required ConnectivitySingleton connectivity})
      : _localDatasource = localDatasource,
        _remoteDatasource = remoteDatasource,
        _connectivity = connectivity;

  Stream<bool> get connectivityStream  => _connectivity.connectionChange;

  void dispose(){
    _connectivity.dispose();
  }
  @override
  Future<void> add(Transaction transaction) async {
    //create DTO model for infra layer from incoming transaction.
    TransactionModel model;
    if (transaction is Expense) {
      model = ExpenseModel(
          amount: transaction.amount,
          category: transaction.category,
          dateTime: transaction.dateTime,
          recurring: transaction.recurring,
          note: transaction.note,
          medium: transaction.medium);
    } else {
      model = IncomeModel(
        amount: transaction.amount,
        category: transaction.category,
        dateTime: transaction.dateTime,
        recurring: transaction.recurring,
      );
    }
    //connectivity
    if(_connectivity.hasConnection){
      await _localDatasource.addTransaction(model);
      return await _remoteDatasource.addTransaction(model);
    }else{
      await _localDatasource.addBuffer(model);
      return await _localDatasource.addTransaction(model);
    }
  }

  @override
  Future<List<Transaction>> getLocal() async {
    var value = await _localDatasource.get();
    return value;
  }

  @override
  Future<List<TransactionModel>> getRemote()async{
    return _remoteDatasource.get();
  }

  @override
  Future<List<Map<String,Object?>>> getBuffer() async{
    return await _localDatasource.getBuffer();
  }

  @override
  Future<void> syncRemoteToLocal()async{
    var map = await _remoteDatasource.get();
    print("remote to local map: $map");
    if(map.isNotEmpty){
      for (var element in map) {
        _localDatasource.addTransaction(element);
      }
    }
  }

  @override
  Future<void> syncLocalToRemote()async{
    var map = await getBuffer();
    print("Check empty buffer");
    print(map);
    await _remoteDatasource.addFromLocalBuffer(map);
    await _localDatasource.clearBuffer();
  }
}
