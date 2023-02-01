import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/application/boundaries/get_transactions/transaction_dto.dart';
import 'package:money_manager/presentation/bloc/home_bloc/home_bloc.dart';

import '../bloc/user_bloc/user_bloc.dart';
import '../constants.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

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
              child: ListView.builder(
                  itemCount: dateTime.length,
                  itemBuilder: (context, dIndex) {
                    return Column(
                      children: [
                        Text(dateTime[dIndex].toString()),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: transaction[dIndex].length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
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
                            );
                          },
                        ),
                      ],
                    );
                  }),
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
                  Center(
                      child: Text("Balance: ${userState.balance}", style: Theme.of(context).textTheme.bodyLarge)),
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
