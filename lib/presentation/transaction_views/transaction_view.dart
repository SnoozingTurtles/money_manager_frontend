import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/infrastructure/factory/entity_factory.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';
import 'package:money_manager/presentation/bloc/transaction_bloc/transaction_bloc.dart';
import '../bloc/home_bloc/home_bloc.dart';
import '../bloc/user_bloc/user_bloc.dart';

List<String> months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

Set<String> category = {
  "Clothing",
  "Education",
  "Entertainment",
  "Food",
  "Fuel",
  "Grooming",
  "Health",
  "Salary",
};

class TransactionView extends StatefulWidget {
  static const String route = "/TransactionScreen";
  const TransactionView({Key? key}) : super(key: key);
  static bool expense = true;
  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
              transactionRepository: RepositoryProvider.of<TransactionRepository>(context),
              userBloc: BlocProvider.of<UserBloc>(context)),
        ),
        BlocProvider<TransactionBloc>(
          create: (context) => TransactionBloc(
              userBloc: BlocProvider.of<UserBloc>(context),
              iEntityFactory: EntityFactory(),
              localId: (BlocProvider.of<UserBloc>(context).state as UserLoaded).localId,
              iTransactionRepository: RepositoryProvider.of<TransactionRepository>(context)),
        ),
      ],
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state.commiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Add Transaction"),
              ),
              body: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.always,
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    _buildExpenseFormField(state, context),
                    FutureBuilder<ListTile>(
                      future: _buildCalendarFormField(context, state),
                      builder: (context, snapshot) => snapshot.hasData ? snapshot.data! : const ListTile(),
                    ),
                    _buildNoteFormField(state, context),
                    _buildSwitches(state, context),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCategoryPicker(state, context),
                        _buildSaveButton(state, context),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  ElevatedButton _buildSaveButton(TransactionState state, BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate() && state.category.value.fold((l) => false, (r) => true)) {
            BlocProvider.of<TransactionBloc>(context).add(
              AddTransaction(id: state.localId),
            );
            BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsThisMonthEvent());
            // BlocProvider.of<AuthBloc>(context).add(const AuthInitialEvent());
            Navigator.pop(context);
          } else if (state.category.value.fold((l) => true, (r) => false)) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Pick a category"),
            ));
          }
        },
        child: const Text("Save"));
  }

  ElevatedButton _buildCategoryPicker(TransactionState state, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: state.category.value.isLeft() ? Colors.red : Colors.blue),
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (ctx) {
            return CategoryPicker(state: state, context: context);
          },
        );
      },
      child: Text(
        state.category.value.fold((l) => true, (r) => false)
            ? "Pick Category"
            : state.category.value.fold((l) => "", (r) => r),
      ),
    );
  }

  ListTile _buildSwitches(TransactionState state, BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.motion_photos_on),
      title: Row(
        children: [
          ChoiceChip(
            selected: state.income,
            onSelected: (val) {
              BlocProvider.of<TransactionBloc>(context).add(FlipIncome());
            },
            label: const Text("Income"),
          ),
          ChoiceChip(
            selected: !state.income,
            label: const Text("Expense"),
            onSelected: (val) {
              BlocProvider.of<TransactionBloc>(context).add(FlipExpense());
            },
          ),
        ],
      ),
    );
  }

  ListTile _buildNoteFormField(TransactionState state, BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.note),
      title: TextFormField(
        validator: (_) => state.note != null ? state.note!.value.fold((l) => l.message, (r) => null) : null,
        onChanged: (value) {
          BlocProvider.of<TransactionBloc>(context).add(ChangeNoteEvent(note: value));
        },
        decoration: mInputDecoration("Note"),
        maxLines: 5,
        maxLength: 50,
      ),
    );
  }

  Future<ListTile> _buildCalendarFormField(BuildContext context, TransactionState state) async {
    return ListTile(
        leading: const Icon(Icons.calendar_month),
        title: Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
              onPressed: () async {
                var date = await showDatePicker(
                        context: context,
                        initialDate: state.dateTime,
                        firstDate: DateTime.now().subtract(const Duration(days: 360)),
                        lastDate: DateTime.now().add(const Duration(days: 360))) ??
                    DateTime.now();

                date = date.add(Duration(
                    hours: DateTime.now().hour,
                    minutes: DateTime.now().minute,
                    seconds: DateTime.now().second,
                    milliseconds: DateTime.now().millisecond));

                debugPrint(date.toIso8601String());
                BlocProvider.of<TransactionBloc>(context).add(ChangeDateEvent(date: date));
              },
              child: Text("${state.dateTime.day} ${months[state.dateTime.month - 1]}")),
        ));
  }

  ListTile _buildExpenseFormField(TransactionState state, BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.currency_rupee),
      title: TextFormField(
        validator: (_) => state.amount.value.fold((l) => l.message, (r) => null),
        onChanged: (value) {
          BlocProvider.of<TransactionBloc>(context).add(ChangeAmountEvent(amount: value));
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: mInputDecoration("Expense"),
        keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
      ),
    );
  }
}

InputDecoration mInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
}

class CategoryPicker extends StatefulWidget {
  final TransactionState state;
  final BuildContext context;
  const CategoryPicker({Key? key, required this.state, required this.context}) : super(key: key);

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  String selectedCategory = "";
  bool showAdder = false;
  static var innerKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<TransactionBloc>(widget.context),
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          return Form(
            key: innerKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: AlertDialog(
              title: const Text("Pick a category that best describes your transaction"),
              content: Wrap(spacing: 5.0, children: [
                ...category.map((categoryText) {
                  selectedCategory = state.category.value.fold((l) => "", (r) => r);
                  return InputChip(
                    label: Text(categoryText),
                    selected: selectedCategory == categoryText,
                    onSelected: (value) {
                      if (selectedCategory == categoryText) {
                        BlocProvider.of<TransactionBloc>(context).add(ChangeCategoryEvent(category: ""));
                      } else {
                        BlocProvider.of<TransactionBloc>(context).add(ChangeCategoryEvent(category: categoryText));
                      }
                    },
                  );
                }).toList(),
                Row(children: [
                  if (showAdder)
                    Expanded(
                      child: TextFormField(
                        initialValue: state.category.value.fold((l) => "", (r) => r),
                        validator: (value) {
                          return state.category.value.fold((l) => l.message, (r) => null);
                        },
                        onChanged: (value) {
                          selectedCategory = value;
                          BlocProvider.of<TransactionBloc>(context).add(ChangeCategoryEvent(category: value));
                        },
                        decoration: mInputDecoration("Category"),
                      ),
                    ),
                  IconButton(
                      icon: Icon(Icons.add_circle_outline_rounded),
                      onPressed: () async {
                        setState(() {
                          showAdder = !showAdder;
                        });
                      }),
                ]),
              ]),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (innerKey.currentState!.validate() && state.category.value.fold((l) => false, (r) => true)) {
                        if (selectedCategory != "") {
                          category.add(selectedCategory);
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Ok")),
                ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<TransactionBloc>(context).add(const ChangeCategoryEvent(category: ""));
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
              ],
            ),
          );
        },
      ),
    );
  }
}
