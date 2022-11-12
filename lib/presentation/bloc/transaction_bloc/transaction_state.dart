part of 'transaction_bloc.dart';

// abstract class TransactionState extends Equatable{
//   const TransactionState();
// }
// class InitialState extends TransactionState{
//   @override
//   List<Object> get props =>[];
// }
// class LoadingState extends TransactionState{
//   @override
//   List<Object?> get props => [];
//
// }

class TransactionState extends Equatable {
  final Amount amount;
  final Category category;
  final Note? note;
  final DateTime dateTime;
  final String medium;
  final bool recurring;
  final String error;
  final bool commiting;

  const TransactionState(
      {required this.amount,
      required this.category,
      this.note,
      required this.dateTime,
      required this.medium,
      required this.recurring,
      required this.error,
      required this.commiting});

  factory TransactionState.initial() {
    return TransactionState(
        amount: Amount(""),
        category: Category(""),
        dateTime: DateTime.now(),
        medium: "Cash",
        recurring: false,
        error: "",
        commiting: false);
  }
  @override
  List<Object> get props => note == null
      ? [amount, category, dateTime, medium, recurring]
      : [amount, category, dateTime, medium, recurring, note!];

  TransactionState copyWith(
      {Amount? amount,
      Category? category,
      Note? note,
      DateTime? dateTime,
      String? medium,
      bool? recurring,
      String? error,
      bool? commiting}) {
    return TransactionState(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      dateTime: dateTime ?? this.dateTime,
      recurring: recurring ?? this.recurring,
      medium: medium ?? this.medium,
      error: error ?? this.error,
      commiting: commiting ?? this.commiting,
    );
  }
}