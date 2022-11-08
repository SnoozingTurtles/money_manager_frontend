import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/bloc/transaction_bloc/transaction_bloc.dart';
import 'package:money_manager/domain/models/transaction_model.dart';
import 'package:money_manager/presentation/constants.dart';

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
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionBloc, TransactionState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    if(state is LoadingState){
      return Center(child: CircularProgressIndicator(),);
    }else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Expense"),
        ),
        body: Form(
            child: ListView(
              padding: EdgeInsets.all(8),
          children: [
            ListTile(
              leading: const Icon(Icons.currency_rupee),
              title: TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 360)),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 360))) ??
                            DateTime.now();

                        setState(() {});
                      },
                      child: Text(
                          "${widget._pickedDate.day} ${months[widget._pickedDate.month - 1]}")),
                )),
            ListTile(
              leading: const Icon(Icons.note),
              title: TextFormField(
                controller: widget.noteController,
                decoration: mInputDecoration("Note"),
                maxLines: 5,
                maxLength: 50,
              ),
            ),
            ListTile(
                leading: Icon(Icons.motion_photos_on),
                title: Row(
                  children: [
                    ChoiceChip(
                      selected: !widget.expense,
                      onSelected: (val){
                        if(val){
                          setState((){widget.expense = false;});
                        }
                      },
                      label: Text("Income"),
                    ),
                    ChoiceChip(
                      selected: widget.expense,
                      label: Text("Expense"),
                      onSelected: (val){
                        if(val){
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
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Enter what you payed for"),
                            content: TextFormField(
                              controller: widget.categoryController,
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context,
                                        widget.categoryController.text);
                                  },
                                  child: Text("Ok")),
                              ElevatedButton(
                                  onPressed: () {
                                    widget.categoryController.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel")),
                            ],
                          );
                        });
                    setState(() {});
                  },
                  child: Text(widget.categoryController.text.isEmpty
                      ? "Pick Category"
                      : widget.categoryController.text),
                ),
                ElevatedButton(
                    onPressed: () async {
                      BlocProvider.of<TransactionBloc>(context).add(AddTransaction(
                          expense: Expense(
                        amount: int.parse(widget.amtController.text),
                        category: widget.categoryController.text,
                        recurring: false,
                        dateTime: widget._pickedDate,
                        medium: "Cash",
                        note: widget.noteController.text,
                      )));
                      Navigator.pop(context);
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
