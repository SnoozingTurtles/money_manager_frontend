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

class Name extends Equatable {
  final Either<Failure, String> name;

  factory Name(String value) {
    return Name._(validateFieldNotEmpty(value));
  }
  const Name._(this.name);

  @override
  List<Object> get props => [name];
}

class Email extends Equatable {
  final Either<Failure, String> email;

  factory Email(String value) {
    return Email._(validateEmail(value));
  }
  const Email._(this.email);

  @override
  List<Object> get props => [email];
}

class Password extends Equatable {
  final Either<Failure, String> password;

  factory Password(String value) {
    return Password._(validatePassword(value));
  }
  factory Password.signUp(String pass, String confirm) {
    return Password._(confirmPassword(pass, confirm));
  }
  const Password._(this.password);

  @override
  List<Object> get props => [password];
}
