import 'package:money_manager/infrastructure/repository/user_repository.dart';

import '../../../domain/value_objects/user/value_objects.dart';

class UpdateUserUseCase {
  final UserRepository _userRepository;

  UpdateUserUseCase({required UserRepository userRepository}) : _userRepository = userRepository;

  Future<void> execute({required UserId remoteId}) async {
    _userRepository.updateUserId(remoteId: remoteId);
  }
}
