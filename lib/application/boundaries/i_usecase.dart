import 'package:dartz/dartz.dart';
import 'package:money_manager/domain/value_objects/value_failure.dart';

import '../../domain/value_objects/user/value_objects.dart';

abstract class IUseCase<TUseCaseInput,TUseCaseOutput>{
  Future<Either<Failure,TUseCaseOutput>> execute({required TUseCaseInput input,UserId? remoteId});
}