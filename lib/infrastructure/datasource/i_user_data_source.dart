import 'package:money_manager/domain/models/user_model.dart';

import '../../domain/value_objects/user/value_objects.dart';

abstract class ILocalUserDataSource{
  Future<int> generateUser();
  Future<void> updateUserId({required UserId remoteId});
  Future<User> getUser(UserId id);
  Future<void> cleanDB();
}