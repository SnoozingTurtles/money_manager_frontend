import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/application/boundaries/get_transactions/transaction_dto.dart';
import 'package:money_manager/presentation/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../domain/models/transaction_model.dart';
import '../bloc/user_bloc/user_bloc.dart';
import '../constants.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);
  late Future<List<Transaction>> tListTest;
  @override
  State<HomeView> createState() => _HomeViewState();
}

var weekday = [
  "SUNDAY",
  "MONDAY",
  "TUESDAY",
  "WEDNESDAY",
  "THURSDAY",
  "FRIDAY",
  "SATURDAY",
];
var month = ["JAN", "FEB", "MAR", "APR", "MAY", "JUNE", "JULY", "AUG", "SEP", "OCT", "NOV", "DEC"];

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 24.0,
            ),
            child: Container(
              width: double.infinity,
              child: Text(
                "Stats for this month",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          _buildBalanceCard(),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 24.0,
            ),
            child: Container(
              width: double.infinity,
              child: Text(
                "Recent Transactions",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          _buildTransactionList(),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return BlocBuilder<DashBoardBloc, DashBoardState>(
      builder: (context, state) {
        if (state is DashBoardLoaded) {
          if (state.transactions.isEmpty) {
            return const Center(child: Text("No recent transactions found"));
          } else {
            var transactions = state.transactions;
            return Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    var transaction = transactions[index];
                    return XListTile(
                      amount: transaction.amount.value.fold((l) => 'error', (r) => r),
                      title: transaction.category.value.fold((l) => 'error', (r) => r),
                      transactionType: transaction,
                      note: transaction.note != null ? transaction.note!.value.fold((l) => "error", (r) => r) : null,
                    );
                  },
                  itemCount: min(state.transactions.length, 7)),
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  BlocConsumer<UserBloc, UserState> _buildBalanceCard() {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        // BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsThisMonthEvent());
      },
      builder: (context, userState) {
        if (userState is UserLoaded) {
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            height: height! * (1 / 4),
            child: Card(
              color: Color.fromRGBO(72, 108, 124, 0.66),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    width: 1.5,
                    color: Colors.white,
                  )),
              elevation: 12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Income: ${userState.income}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                      ),
                      Text("Expense: ${userState.expense}",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white))
                    ],
                  ),
                  Center(
                      child: Text("Balance: ${userState.balance}",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white))),
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class XListTile extends StatelessWidget {
  final String title;
  final TransactionDTO transactionType;
  final String? note;
  final String amount;
  const XListTile({
    required this.amount,
    required this.title,
    required this.transactionType,
    required this.note,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
      child: ListTile(
        tileColor: Color.fromRGBO(72, 108, 124, 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Image.asset('assets/common/subscription.png'),
        title: Text(
          style: Theme.of(context).textTheme.bodyMedium,
          title,
        ),
        trailing: SizedBox(
          width: width! * 1 / 5,
          child: Column(
            children: [
              transactionType is IncomeDTO
                  ? Text(
                      '+ Rs ${amount}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.green),
                    )
                  : Text(
                      '- Rs ${amount}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.red),
                    ),
              Text("10:00 AM"),
            ],
          ),
        ),
        subtitle: Text(
          note != null ? note! : "null",
        ),
      ),
    );
  }
}
