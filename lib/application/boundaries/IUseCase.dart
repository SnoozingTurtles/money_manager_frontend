import 'package:dartz/dartz.dart';
import 'package:money_manager/domain/value_objects/value_failure.dart';

abstract class IUseCase<TUseCaseInput,TUseCaseOutput>{
  Future<Either<Failure,TUseCaseOutput>> execute(TUseCaseInput input);
}