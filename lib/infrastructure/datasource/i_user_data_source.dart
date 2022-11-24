import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';
import 'package:money_manager/infrastructure/model/model.dart';

abstract class IUserDataSource{
  Future<int> generateUser();
  Future<int> addUser(UserModel user);
  Future<UserModel> getUser(UserId id);
}