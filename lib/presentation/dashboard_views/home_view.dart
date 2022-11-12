import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/application/boundaries/get_all_transactions/transaction_dto.dart';
import 'package:money_manager/presentation/bloc/home_bloc/home_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
            return ListView.builder(
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
                      transaction[index].note!=null?transaction[index].note!.value.fold((l) => "null", (r) =>r):"null",
                    ),
                  );
                });
          }
        }
        return const Center(child: Text("Unexpected error occurred"));
      },
    );
  }
}
