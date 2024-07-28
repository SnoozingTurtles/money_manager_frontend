import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/infrastructure/factory/entity_factory.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';
import 'package:money_manager/presentation/auth_views/widgets/widgets.dart';
import 'package:money_manager/presentation/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:money_manager/presentation/bloc/transaction_form_bloc/transaction_form_bloc.dart';

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

class TransactionFormView extends StatefulWidget {
  static const String route = "/TransactionScreen";
  const TransactionFormView({Key? key}) : super(key: key);

  static final formKey = GlobalKey<FormState>();

  @override
  State<TransactionFormView> createState() => _TransactionFormViewState();

  Widget _buildCategoryPicker(TransactionFormState state, BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.category),
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

  ListTile _buildSwitches(TransactionFormState state, BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.motion_photos_on),
      title: Row(
        children: [
          ChoiceChip(
            selected: state.income,
            onSelected: (val) {
              BlocProvider.of<TransactionFormBloc>(context).add(FlipIncome());
            },
            label: const Text("Income"),
          ),
          ChoiceChip(
            selected: !state.income,
            label: const Text("Expense"),
            onSelected: (val) {
              BlocProvider.of<TransactionFormBloc>(context).add(FlipExpense());
            },
          ),
        ],
      ),
    );
  }

  ListTile _buildNoteFormField(TransactionFormState state, BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.note),
      title: TextFormField(
        validator: (_) => state.note?.value.fold((l) => l.message, (r) => null),
        onChanged: (value) {
          BlocProvider.of<TransactionFormBloc>(context).add(ChangeNoteEvent(note: value));
        },
        decoration: mInputDecoration("Description"),
        maxLines: 3,
        maxLength: 50,
      ),
    );
  }

  Future<ListTile> _buildCalendarFormField(BuildContext context, TransactionFormState state) async {
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
                if (context.mounted) {
                  BlocProvider.of<TransactionFormBloc>(context).add(ChangeDateEvent(date: date));
                }
              },
              child: TextFormField(
                decoration: mInputDecoration('Date'),
                controller: TextEditingController(text: "${state.dateTime.day} ${months[state.dateTime.month - 1]}"),
                enabled: false,
              ),
            )));
  }

  Widget _buildExpenseFormField(TransactionFormState state, BuildContext context) {
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
              BlocProvider.of<TransactionFormBloc>(context).add(ChangeAmountEvent(amount: value));
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(TransactionFormState state, BuildContext context) {
    return XButton(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 13,
        alter: false,
        onPressed: () {
          if (formKey.currentState!.validate() &&
              state.amount.value.fold((l) => false, (r) => true) &&
              state.category.value.fold((l) => false, (r) => true)) {
            BlocProvider.of<TransactionFormBloc>(context).add(
              AddTransaction(id: state.localId),
            );
            // BlocProvider.of<DashBoardBloc>(context).add(const LoadTransactionsThisMonthEvent());
            // Navigator.pop(context);
          } else if (state.category.value.fold((l) => true, (r) => false)) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Pick a category"),
            ));
          } else if (state.amount.value.fold((l) => true, (r) => false)) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Enter a valid amount"),
            ));
          }
        },
        text: "Save");
  }
}

class _TransactionFormViewState extends State<TransactionFormView> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionFormBloc>(
          create: (context) => TransactionFormBloc(
              userBloc: BlocProvider.of<UserBloc>(context),
              iEntityFactory: EntityFactory(),
              localId: (BlocProvider.of<UserBloc>(context).state as UserLoaded).localId,
              iTransactionRepository: RepositoryProvider.of<TransactionRepository>(context))
            ..add(LoadCategoryEvent()),
        ),
      ],
      child: SafeArea(
        child: BlocConsumer<TransactionFormBloc, TransactionFormState>(
          listener: (context, state) {
            if (state.saving == false) {
              BlocProvider.of<DashBoardBloc>(context).add(const LoadTransactionsThisMonthEvent());
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: state.income ? Colors.green : const Color.fromRGBO(253, 60, 74, 0.61),
              body: Form(
                key: TransactionFormView.formKey,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      left: 24.0,
                      right: 24.0,
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(state.income ? 'Income' : 'Expense',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white)),
                      IconButton(
                        icon: const Icon(
                          Icons.currency_exchange,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          BlocProvider.of<TransactionFormBloc>(context).add(FlipIncome());
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
                      shape: const RoundedRectangleBorder(
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
  final TransactionFormState state;
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
      value: BlocProvider.of<TransactionFormBloc>(widget.context),
      child: BlocBuilder<TransactionFormBloc, TransactionFormState>(
        builder: (context, state) {
          return Form(
            key: innerKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: AlertDialog(
              title: const Text("Pick a category that best describes your transaction"),
              content: Wrap(spacing: 5.0, children: [
                ...state.availableCategories.map((category) {
                  var categoryText = category.value.fold((l) => "", (r) => r);
                  selectedCategory = state.category.value.fold((l) => "", (r) => r);
                  return InputChip(
                    label: Text(categoryText),
                    selected: selectedCategory == categoryText,
                    onSelected: (value) {
                      if (selectedCategory == categoryText) {
                        BlocProvider.of<TransactionFormBloc>(context).add(const ChangeCategoryEvent(category: ""));
                      } else {
                        BlocProvider.of<TransactionFormBloc>(context).add(ChangeCategoryEvent(category: categoryText));
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
                          BlocProvider.of<TransactionFormBloc>(context).add(ChangeCategoryEvent(category: value));
                        },
                        decoration: mInputDecoration("Category"),
                      ),
                    ),
                  IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded),
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
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Ok")),
                ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<TransactionFormBloc>(context).add(const ChangeCategoryEvent(category: ""));
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
