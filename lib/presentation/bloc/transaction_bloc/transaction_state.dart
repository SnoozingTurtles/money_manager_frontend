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
  final UserId localId;
  final Amount amount;
  final Category category;
  final Note? note;
  final DateTime dateTime;
  final String medium;
  final bool recurring;
  final String error;
  final bool commiting;
  final bool income;

  const TransactionState(
      {required this.amount,
      required this.localId,
      required this.income,
      required this.category,
      this.note,
      required this.dateTime,
      required this.medium,
      required this.recurring,
      required this.error,
      required this.commiting});

  factory TransactionState.initial(UserId id) {
    return TransactionState(
        amount: Amount(""),
        category: Category(""),
        income: false,
        dateTime: DateTime.now(),
        localId: id,
        medium: "Cash",
        recurring: false,
        error: "",
        commiting: false);
  }
  @override
  List<Object> get props => note == null
      ? [amount, category, dateTime, medium, recurring,income]
      : [amount, category, dateTime, medium, recurring, note!,income];

  TransactionState copyWith(
      {Amount? amount,
      Category? category,
      Note? note,
      DateTime? dateTime,
      String? medium,
      bool? recurring,
      String? error,
      bool? income,
      bool? commiting}) {
    return TransactionState(
      income: income ?? this.income,
      localId: localId,
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
