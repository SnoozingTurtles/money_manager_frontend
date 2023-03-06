import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:money_manager/application/boundaries/get_transactions/transaction_dto.dart';

extension Iterables<E> on Iterable<E> {
  SplayTreeMap<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
        SplayTreeMap<K, List<E>>(),
        (SplayTreeMap<K, List<E>> map, E element) => map..putIfAbsent(keyFunction(element), () => <E>[]).add(element),
      );
}

class MapTransactionUseCase {
  MapTransactionUseCase();

  Future<SplayTreeMap<String, List<TransactionDTO>>> generateOutput(List<TransactionDTO> transactions) async {
    var test = transactions.groupBy((p0) => p0.dateTime.toString().substring(0, 10));
    var output = test.map((key, value) => MapEntry(key, test[key]!.toList()));

    return SplayTreeMap.from(output);
  }
}
