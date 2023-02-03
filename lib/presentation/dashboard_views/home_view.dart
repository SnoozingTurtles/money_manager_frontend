import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/application/boundaries/get_transactions/transaction_dto.dart';
import 'package:money_manager/application/usecases/get_transaction_usecase.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';
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

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsThisMonthEvent());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // if (state.syncLoading) const LinearProgressIndicator(),
          _buildBalanceCard(),
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
        itemCount: dateTime.length,
        itemBuilder: (context, dIndex) {
          return Column(
            children: [
              RawChip(label: Text(dateTime[dIndex].toString())),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transaction[dIndex].length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: ListTile(
                      title: Text(
                        transaction[dIndex][index].category.value.fold((l) => "Error", (r) => r),
                      ),
                      trailing: SizedBox(
                        width: width! * 1 / 5,
                        child: Row(
                          children: [
                            Text(
                              transaction[dIndex][index].amount.value.fold((l) => "Error", (r) => r),
                            ),
                            transaction[dIndex][index] is IncomeDTO
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
                        transaction[dIndex][index].note != null
                            ? transaction[dIndex][index].note!.value.fold((l) => "null", (r) => r)
                            : "null",
                      ),
                    ),
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
        BlocProvider.of<HomeBloc>(context).add(const LoadTransactionsThisMonthEvent());
      },
      builder: (context, userState) {
        if (userState is UserLoaded) {
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            height: height! * (1 / 4),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Income: ${userState.income}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text("Expense: ${userState.expense}", style: Theme.of(context).textTheme.bodyLarge)
                    ],
                  ),
                  Center(child: Text("Balance: ${userState.balance}", style: Theme.of(context).textTheme.bodyLarge)),
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
