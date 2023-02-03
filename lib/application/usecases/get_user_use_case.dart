import '../../domain/models/user_model.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../../domain/value_objects/user/value_objects.dart';

class GetUserUseCase{
  final IUserRepository userRepository;

  GetUserUseCase(this.userRepository);

  Future<User> execute() async{
    User user = await userRepository.get(UserId(1));
    return user;
  }
}