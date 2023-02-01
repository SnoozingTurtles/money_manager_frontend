import 'package:dartz/dartz.dart';
import 'package:money_manager/domain/value_objects/value_failure.dart';

import '../value_objects/user/value_objects.dart';

abstract class IAuthRepository{
  Future<Either<Failure,UserId>> signUp({required Email email,required String name,required Password password});
  Future<Either<Failure,UserId>> signIn({required Email email,required Password password});
}