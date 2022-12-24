import 'package:money_manager/domain/repositories/i_user_repository.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

import '../../domain/models/user_model.dart';
import '../../domain/value_objects/user/value_objects.dart';

class GenerateUserUseCase{
  final IUserRepository userRepository;

  GenerateUserUseCase(this.userRepository);

  Future<User> execute() async{
    int id = await userRepository.generateUser();
    return User(userId: UserId(id), balance: 0,expense:0,income:0,loggedIn: false);
  }
}