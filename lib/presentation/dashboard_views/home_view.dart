import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/application/boundaries/get_transactions/transaction_dto.dart';
import 'package:money_manager/presentation/bloc/home_bloc/home_bloc.dart';
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
    // BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsThisMonthEvent());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
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

  BlocBuilder<HomeBloc, HomeState> _buildTransactionList() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          if (state.transactions.isEmpty) {
            return const Center(child: Text("No recent transactions found"));
          } else {
            List<String> dateTime = state.transactions.keys.toList().reversed.toList();
            List<List<TransactionDTO>> transaction = state.transactions.values.toList().reversed.toList();
            return Expanded(
              child: listView(dateTime, transaction),
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  FutureBuilder<List<Transaction>> futureBuilderListUsingPackage() {
    return FutureBuilder(
        future: widget.tListTest,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var output = snapshot.data!.map((e) => e is Expense ? ExpenseDTO.fromEntity(e) : IncomeDTO.fromEntity(e));
            debugPrint("INIT STATE ${output}");
            return GroupedListView(
              elements: snapshot.data!,
              order: GroupedListOrder.DESC,
              groupBy: (element) {
                DateTime value = DateTime(element.dateTime.year, element.dateTime.month, element.dateTime.day);
                return value;
              },
              groupComparator: (value1, value2) {
                DateTime onlyDate1 = DateTime(value1.year, value1.month, value1.day);
                DateTime onlyDate2 = DateTime(value2.year, value2.month, value2.day);
                return onlyDate1.compareTo(onlyDate2);
              },
              groupSeparatorBuilder: (value) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              itemBuilder: (context, element) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: SizedBox(
                    child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        title: Text(element.category.value.fold((l) => "null", (r) => r)),
                        trailing: SizedBox(
                          width: width! * 1 / 5,
                          child: Row(
                            children: [
                              Text(
                                element.amount.value.fold((l) => "Error", (r) => r),
                              ),
                              element is IncomeDTO
                                  ? const Icon(
                                      Icons.arrow_upward,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.red,
                                    )
                            ],
                          ),
                        ),
                        subtitle: Text(
                          element.note != null ? element.note!.value.fold((l) => "null", (r) => r) : "null",
                        )),
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        });
  }

  ListView listView(List<String> dateTime, List<List<TransactionDTO>> transaction) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dateTime.length < 3 ? dateTime.length : 3,
        itemBuilder: (context, dIndex) {
          return Column(
            children: [
              // RawChip(label: Text(dateTime[dIndex].toString())),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transaction[dIndex].length < 3 ? transaction[dIndex].length : 3,
                itemBuilder: (BuildContext context, int index) {
                  return XListTile(
                    amount: transaction[dIndex][index].amount.value.fold((l) => "Error", (r) => r),
                    title: transaction[dIndex][index].category.value.fold((l) => "Error", (r) => r),
                    note: transaction[dIndex][index].note == null
                        ? null
                        : transaction[dIndex][index].note!.value.fold((l) => "null", (r) => r),
                    transactionType: transaction[dIndex][index],
                  );
                },
              ),
            ],
          );
        });
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
