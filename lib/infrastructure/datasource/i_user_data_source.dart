import '../../domain/value_objects/user/value_objects.dart';
import '../model/infra_user_model.dart';

abstract class ILocalUserDataSource{
  Future<int> generateUser();
  Future<int> addUser(UserModel user);
  Future<UserModel> getUser(UserId id);
  Future<void> cleanDB();
}