import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:money_manager/domain/value_objects/value_failure.dart';

//calculator validation logic here if made.
Either<Failure, String> validateFieldNotEmpty(String input) {
  if (input.isNotEmpty) {
    return right(input);
  } else {
    return left(Failure("Can't be empty"));
  }
}

Either<Failure, String> validateEmail(String input) {
  if (input.isNotEmpty && input.contains("@")) {
    return right(input);
  } else {
    return left(Failure("Invalid Email"));
  }
}

Either<Failure, String> validatePassword(String input) {
  if (input.isNotEmpty && input.length >= 5) {
    return right(input);
  } else {
    return left(Failure("Try another password"));
  }
}

Either<Failure, String> confirmPassword(String pass, String val) {
  if (val == pass) {
    return right(pass);
  } else {
    return left(Failure("Passwords do not match"));
  }
}

Either<Failure, String> validateAmount(String amount) {
  String regex = "^\\d+\$";
  if (RegExp(regex).hasMatch(amount) && int.parse(amount) != 0) {
    return right(amount);
  } else {
    return left(
      Failure("Invalid amount"),
    );
  }
}

Either<Failure, String> validateMaxStringLength(String input, int maxLength) {
  if (input.length <= maxLength) {
    return right(input);
  } else {
    return left(Failure("Exceeds 150 characters"));
  }
}

Either<Failure, String> validateSingleLine(String input) {
  if (!input.contains("\n")) {
    return right(input);
  } else {
    return left(Failure("Multiple lines not allowed"));
  }
}
