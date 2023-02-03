class ValueFailure<T>{
  T failedValue;
  ValueFailure({required this.failedValue});

  @override
  String toString() {
    return failedValue.toString();
  }
}

class Failure{
  String? message;

  Failure(this.message);
}