import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/application/boundaries/get_all_transactions/transaction_dto.dart';
import 'package:money_manager/infrastructure/repository/model_repository.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';
import 'package:money_manager/presentation/bloc/home_bloc/home_bloc.dart';

import '../../infrastructure/repository/user_repository.dart';
import '../bloc/user_bloc/user_bloc.dart';
import '../constants.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Stream<bool> connectivityStream;

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  //   print('disposing stream');
  //   RepositoryProvider.of<TransactionRepository>(context).dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          print("Listener $state.user.balance");
        }
      },
      builder: (context, userState) {
        return BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeLoaded && userState is UserLoaded) {
                if (state.transactions.isEmpty) {
                  return const Center(child: Text("No recent transactions found"));
                } else {
                  return SafeArea(
                    child: Column(
                      children: [
                        if (state.syncLoading) LinearProgressIndicator(),
                        Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          height: sh! * (1 / 4),
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
                                      "Income: ${userState.user.income}",
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text("Expense: ${userState.user.expense}",
                                        style: Theme.of(context).textTheme.bodyLarge)
                                  ],
                                ),
                                Center(
                                    child: Text("Balance: ${userState.user.balance}",
                                        style: Theme.of(context).textTheme.bodyLarge)),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.transactions.length,
                            itemBuilder: (BuildContext context, int index) {
                              UnmodifiableListView<TransactionDTO> transaction = state.transactions;
                              print(transaction[index].toString());
                              return ListTile(
                                title: Text(
                                  transaction[index].category.value.fold((l) => "Error", (r) => r),
                                ),
                                trailing: SizedBox(
                                  width:sw!*1/5,
                                  child: Row(
                                    children: [
                                      Text(
                                        transaction[index].amount.value.fold((l) => "Error", (r) => r),
                                      ),
                                      transaction[index] is IncomeDTO? Icon(Icons.arrow_upward,color: Colors.green,):Icon(Icons.arrow_downward,color: Colors.red,)
                                    ],
                                  ),
                                ),
                                subtitle: Text(
                                  transaction[index].note != null
                                      ? transaction[index].note!.value.fold((l) => "null", (r) => r)
                                      : "null",
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
      },
    );
  }
}
