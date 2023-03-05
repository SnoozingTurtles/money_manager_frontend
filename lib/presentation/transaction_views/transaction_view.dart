import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/infrastructure/factory/entity_factory.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';
import 'package:money_manager/presentation/auth_views/widgets/widgets.dart';
import 'package:money_manager/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:money_manager/presentation/bloc/transaction_bloc/transaction_bloc.dart';

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

  static final formKey = GlobalKey<FormState>();

  @override
  State<TransactionView> createState() => _TransactionViewState();

  Widget _buildCategoryPicker(TransactionState state, BuildContext context) {
    return ListTile(
      leading: Icon(Icons.category),
      title: InkWell(
        onTap: () async {
          await showDialog(
            context: context,
            builder: (ctx) {
              return CategoryPicker(state: state, context: context);
            },
          );
        },
        child: TextFormField(
          decoration: mInputDecoration('Category'),
          enabled: false,
          validator: (_) => state.category.value.fold((l) => l.message, (r) => null),
          // style: ElevatedButton.styleFrom(backgroundColor: state.category.value.isLeft() ? Colors.red : Colors.blue),
          controller: TextEditingController(
            text: state.category.value.fold((l) => true, (r) => false)
                ? "Pick Category"
                : state.category.value.fold((l) => "", (r) => r),
          ),
        ),
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
        decoration: mInputDecoration("Description"),
        maxLines: 3,
        maxLength: 50,
      ),
    );
  }

  Future<ListTile> _buildCalendarFormField(BuildContext context, TransactionState state) async {
    return ListTile(
        leading: const Icon(Icons.calendar_month),
        title: Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () async {
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
              child: TextFormField(
                decoration: mInputDecoration('Date'),
                controller: TextEditingController(text: "${state.dateTime.day} ${months[state.dateTime.month - 1]}"),
                enabled: false,
              ),
            )));
  }

  Widget _buildExpenseFormField(TransactionState state, BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Rs", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white)),
        ),
        Expanded(
          child: TextFormField(
            style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "0",
                hintStyle: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.white)),
            // validator: (_) => state.amount.value.fold((l) => l.message, (r) => null),
            onChanged: (value) {
              BlocProvider.of<TransactionBloc>(context).add(ChangeAmountEvent(amount: value));
            },

            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(TransactionState state, BuildContext context) {
    return XButton(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 13,
        alter: false,
        onPressed: () async {
          if (formKey.currentState!.validate() &&
              state.amount.value.fold((l) => false, (r) => true) &&
              state.category.value.fold((l) => false, (r) => true)) {
            BlocProvider.of<TransactionBloc>(context).add(
              AddTransaction(id: state.localId),
            );
            BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsThisMonthEvent());
            Navigator.pop(context);
          } else if (state.category.value.fold((l) => true, (r) => false)) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Pick a category"),
            ));
          }else if(state.amount.value.fold((l)=>true,(r)=>false)){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Enter a valid amount"),
            ));
          }
        },
        text: "Save");
  }
}

class _TransactionViewState extends State<TransactionView> {
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
      child: SafeArea(
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: state.income ? Colors.green : Colors.red,
              body: Form(
                key: TransactionView.formKey,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      left: 24.0,
                      right: 24.0,
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text('${state.income ? 'Income' : 'Expense'}',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white)),
                      IconButton(
                        icon: Icon(
                          Icons.currency_exchange,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          BlocProvider.of<TransactionBloc>(context).add(FlipIncome());
                        },
                      )
                    ]),
                  ),
                  Expanded(
                    child: Align(alignment: Alignment.bottomLeft, child: widget._buildExpenseFormField(state, context)),
                  ),
                  Expanded(
                    flex: 2,
                    child: BottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                      ),
                      onClosing: () {},
                      builder: (context) => ListView(
                        padding: const EdgeInsets.all(8),
                        children: [
                          FutureBuilder<ListTile>(
                            future: widget._buildCalendarFormField(context, state),
                            builder: (context, snapshot) => snapshot.hasData ? snapshot.data! : const ListTile(),
                          ),
                          widget._buildNoteFormField(state, context),
                          widget._buildSwitches(state, context),
                          widget._buildCategoryPicker(state, context),
                          widget._buildSaveButton(state, context),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
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


InputDecoration mInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
}