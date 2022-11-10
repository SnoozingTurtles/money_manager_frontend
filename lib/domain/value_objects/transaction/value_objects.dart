import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:money_manager/domain/value_objects/value_failure.dart';
import 'package:money_manager/domain/value_objects/value_validators.dart';

class Amount extends Equatable {
  final Either<Failure, String> value;

  factory Amount(String value) {
    return Amount._(validateFieldNotEmpty(value).flatMap(validateAmount));
  }
  const Amount._(this.value);

  @override
  List<Object?> get props => [value];
}

class Note extends Equatable {
  final Either<Failure, String> value;
  static const maxLength = 150;

  factory Note(String value) {
    return Note._(validateMaxStringLength(value, maxLength));
  }
  const Note._(this.value);

  @override
  List<Object?> get props => [value];
}

class Category extends Equatable {
  final Either<Failure, String> value;

  factory Category(String value) {
    return Category._(
      validateSingleLine(value)
          .flatMap((string) => validateMaxStringLength(string, 10)),
    );
  }
  const Category._(this.value);

  @override
  List<Object?> get props => [value];
}
