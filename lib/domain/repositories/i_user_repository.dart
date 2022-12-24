import 'package:money_manager/domain/models/user_model.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

import '../value_objects/user/value_objects.dart';

abstract class IUserRepository{
  Future<int> generateUser();
  Future<void> updateUserId({required UserId remoteId});
  Future<User> get(UserId id);
}