class ValueFailure<T>{
  T failedValue;
  ValueFailure({required this.failedValue});

  @override
  String toString() {
    return failedValue.toString();
  }
}

class Failure{
  String message;

  Failure(this.message);
}
class InvalidAmount<T> extends ValueFailure<T>{
  InvalidAmount({required super.failedValue});
}

class ExceedingLength<T> extends ValueFailure<T>{
  int max;

  ExceedingLength({required this.max, required T failedValue}):super(failedValue: failedValue);
}
class MultiLine<T> extends ValueFailure<T>{
  MultiLine({required super.failedValue});
}
class FieldNotEmpty<T> extends ValueFailure<T>{
  FieldNotEmpty({required super.failedValue});
}