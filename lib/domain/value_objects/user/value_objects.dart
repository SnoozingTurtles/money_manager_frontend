import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:money_manager/domain/value_objects/value_failure.dart';
import 'package:money_manager/domain/value_objects/value_validators.dart';

class UserId extends Equatable {
  final int value;

  factory UserId(int value) {
    return UserId._(value);
  }
  const UserId._(this.value);

  @override
  List<Object> get props => [value];
}

class Email extends Equatable {
  final Either<Failure,String> email;

  factory Email(String value) {
    return Email._(validateEmail(value));
  }
  const Email._(this.email);

  @override
  List<Object> get props => [email];
}
class Password extends Equatable {
  final Either<Failure,String> password;

  factory Password(String value) {
    return Password._(validatePassword(value));
  }
  const Password._(this.password);

  @override
  List<Object> get props => [password];
}
