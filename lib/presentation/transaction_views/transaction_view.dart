import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/presentation/bloc/transaction_bloc/transaction_bloc.dart';

import '../bloc/home_bloc/home_bloc.dart';

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

class TransactionView extends StatefulWidget {
  static const String route = "transaction_view";
  const TransactionView({Key? key}) : super(key: key);
  static bool expense = true;
  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  static final formkey = GlobalKey<FormState>();
  static var innerKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
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
              key: formkey,
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
    );
  }

  ElevatedButton _buildSaveButton(TransactionState state, BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          if (formkey.currentState!.validate() && state.category.value.fold((l) => false, (r) => true)) {
            BlocProvider.of<TransactionBloc>(context).add(
              AddTransaction(id: state.localId),
            );
            BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsThisMonthEvent());

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
            return Form(
              key: innerKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: AlertDialog(
                title: const Text("Enter what you payed for"),
                content: TextFormField(
                  initialValue: state.category.value.fold((l) => "", (r) => r),
                  validator: (value) {
                    return state.category.value.fold((l) => l.message, (r) => null);
                  },
                  onChanged: (value) {
                    BlocProvider.of<TransactionBloc>(context).add(ChangeCategoryEvent(category: value));
                  },
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Ok")),
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<TransactionBloc>(context).add(ChangeCategoryEvent(category: ""));
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                ],
              ),
            );
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
