import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/application/boundaries/add_transaction/add_transaction_input.dart';
import 'package:money_manager/bloc/transaction_bloc/transaction_bloc.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

class TransactionView extends StatefulWidget {
  DateTime _pickedDate = DateTime.now();
  TextEditingController amtController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  static const String route = "transaction_view";
  TransactionView({Key? key}) : super(key: key);
  bool expense = true;
  @override
  State<TransactionView> createState() => _TransactionViewState();
}

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

class _TransactionViewState extends State<TransactionView> {
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Expense"),
              ),
              body: Form(
                  key: key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.currency_rupee),
                        title: TextFormField(
                          validator: (value) => Amount(value!)
                              .value
                              .fold((l) => l.message, (r) => null),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: mInputDecoration("Expense"),
                          controller: widget.amtController,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: false, decimal: true),
                        ),
                      ),
                      ListTile(
                          leading: const Icon(Icons.calendar_month),
                          title: Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                                onPressed: () async {
                                  widget._pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: widget._pickedDate,
                                          firstDate: DateTime.now().subtract(
                                              const Duration(days: 360)),
                                          lastDate: DateTime.now().add(
                                              const Duration(days: 360))) ??
                                      DateTime.now();

                                  setState(() {});
                                },
                                child: Text(
                                    "${widget._pickedDate.day} ${months[widget._pickedDate.month - 1]}")),
                          )),
                      ListTile(
                        leading: const Icon(Icons.note),
                        title: TextFormField(
                          validator: (value) => Note(value!)
                              .value
                              .fold((l) => l.message, (r) => null),
                          controller: widget.noteController,
                          decoration: mInputDecoration("Note"),
                          maxLines: 5,
                          maxLength: 50,
                        ),
                      ),
                      ListTile(
                          leading: const Icon(Icons.motion_photos_on),
                          title: Row(
                            children: [
                              ChoiceChip(
                                selected: !widget.expense,
                                onSelected: (val) {
                                  if (val) {
                                    setState(() {
                                      widget.expense = false;
                                    });
                                  }
                                },
                                label: const Text("Income"),
                              ),
                              ChoiceChip(
                                selected: widget.expense,
                                label: const Text("Expense"),
                                onSelected: (val) {
                                  if (val) {
                                    setState(() {
                                      widget.expense = true;
                                    });
                                  }
                                },
                              ),
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    widget.categoryController.text.isEmpty
                                        ? Colors.red
                                        : Colors.blue),
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Form(
                                      autovalidateMode: AutovalidateMode.always,
                                      child: AlertDialog(
                                        title: const Text(
                                            "Enter what you payed for"),
                                        content: TextFormField(
                                          validator: (value) => Category(value!)
                                              .value
                                              .fold((l) => l.message,
                                                  (r) => null),
                                          controller: widget.categoryController,
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context,
                                                    widget.categoryController
                                                        .text);
                                              },
                                              child: const Text("Ok")),
                                          ElevatedButton(
                                              onPressed: () {
                                                widget.categoryController
                                                    .clear();
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancel")),
                                        ],
                                      ),
                                    );
                                  });
                              setState(() {});
                            },
                            child: Text(
                              widget.categoryController.text.isEmpty
                                  ? "Pick Category"
                                  : widget.categoryController.text,
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                if (key.currentState!.validate() &&
                                    widget.categoryController.text.isNotEmpty) {
                                  BlocProvider.of<TransactionBloc>(context).add(
                                    AddTransaction(
                                      addExpenseInput: AddExpenseInput(
                                        amount:
                                            Amount(widget.amtController.text),
                                        recurring: false,
                                        dateTime: widget._pickedDate,
                                        category: Category(
                                            widget.categoryController.text),
                                        medium: "Cash",
                                        note: Note(widget.noteController.text),
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }else if (widget.categoryController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Pick a category"),
                                  ));
                                }
                              },
                              child: const Text("Save")),
                        ],
                      )
                    ],
                  )));
        }
      },
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
