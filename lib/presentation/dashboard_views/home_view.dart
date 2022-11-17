import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/application/boundaries/get_all_transactions/transaction_dto.dart';
import 'package:money_manager/infrastructure/repository/model_repository.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';
import 'package:money_manager/presentation/bloc/home_bloc/home_bloc.dart';

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

@override
  void dispose() {
    print('disposing stream');
    RepositoryProvider.of<TransactionRepository>(context).dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(child: Text("No recent transactions found"));
            } else {
              return Column(
                children: [
                  if(state.syncLoading)
                    LinearProgressIndicator(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.transactions.length,
                      itemBuilder: (BuildContext context, int index) {
                        UnmodifiableListView<TransactionDTO> transaction = state.transactions;
                        return ListTile(
                          title: Text(
                            transaction[index].category.value.fold((l) => "Error", (r) => r),
                          ),
                          trailing: Text(
                            transaction[index].amount.value.fold((l) => "Error", (r) => r),
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
              );
            }
          } else {
            return const Center(child: Text("Unexpected error occurred"));
          }
        });
  }
}
