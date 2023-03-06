part of 'transaction_form_bloc.dart';

class TransactionFormState extends Equatable {
  final UserId localId;
  final Amount amount;
  final Category category;
  final Note? note;
  final DateTime dateTime;
  final String medium;
  final bool recurring;
  final String error;
  final bool saving;
  final bool income;
  final Set<Category> availableCategories;

  const TransactionFormState(
      {required this.amount,
      required this.availableCategories,
      required this.localId,
      required this.income,
      required this.category,
      this.note,
      required this.dateTime,
      required this.medium,
      required this.recurring,
      required this.error,
      required this.saving});

  factory TransactionFormState.initial(UserId localId) {
    return TransactionFormState(
        amount: Amount(""),
        category: Category(""),
        income: false,
        dateTime: DateTime.now(),
        localId: localId,
        medium: "Cash",
        recurring: false,
        error: "",
        availableCategories: {
          Category("Clothing"),
          Category("Education"),
          Category("Entertainment"),
          Category("Food"),
          Category("Fuel"),
          Category("Grooming"),
          Category("Health"),
          Category("Salary"),
        },
        saving: true);
  }
  @override
  List<Object> get props => note == null
      ? [amount, category, dateTime, medium, recurring, income, saving]
      : [amount, category, dateTime, medium, recurring, note!, income, saving];

  TransactionFormState copyWith(
      {Amount? amount,
      Category? category,
      Note? note,
      DateTime? dateTime,
      String? medium,
      bool? recurring,
      String? error,
      Set<Category>? availableCategories,
      bool? income,
      bool? saving}) {
    return TransactionFormState(
      income: income ?? this.income,
      availableCategories: availableCategories ?? this.availableCategories,
      localId: localId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      dateTime: dateTime ?? this.dateTime,
      recurring: recurring ?? this.recurring,
      medium: medium ?? this.medium,
      error: error ?? this.error,
      saving: saving ?? this.saving,
    );
  }
}
