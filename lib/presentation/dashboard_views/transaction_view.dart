import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/presentation/bloc/home_bloc/home_bloc.dart';

import '../../application/boundaries/get_transactions/transaction_dto.dart';
import 'home_view.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({Key? key}) : super(key: key);
  ListView listView(List<String> dateTime, List<List<TransactionDTO>> transaction) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          if (state.transactions.isEmpty) {
            return const Center(child: Text("No recent transactions found"));
          } else {
            List<String> dateTime = state.transactions.keys.toList().reversed.toList();
            List<List<TransactionDTO>> transaction = state.transactions.values.toList().reversed.toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Expanded(
                child: listView(dateTime, transaction),
              ),
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
