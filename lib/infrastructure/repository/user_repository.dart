import 'package:money_manager/domain/models/user_model.dart';
import 'package:money_manager/domain/repositories/i_user_repository.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';
import 'package:money_manager/infrastructure/datasource/i_user_data_source.dart';

import '../factory/entity_factory.dart';

class UserRepository extends IUserRepository{
  final IUserDataSource _localDatasource;
  final EntityFactory _entityFactory;
  UserRepository(
      {required IUserDataSource localDatasource,required EntityFactory entityFactory})
      : _localDatasource = localDatasource,_entityFactory=entityFactory;

  @override
  Future<int> addUser(User user) {
    // TODO: implement addUser
    throw UnimplementedError();
  }

  @override
  Future<int> generateUser() async{
    print('generate user');
    int val = await _localDatasource.generateUser();
    return val;
  }

  @override
  Future<User> get(UserId id) async{
    var val = await _localDatasource.getUser(id);
    print(val.balance);
    return _entityFactory.newUser(uid:val.userId,balance: val.balance,expense:val.expense,income:val.income);
  }
}