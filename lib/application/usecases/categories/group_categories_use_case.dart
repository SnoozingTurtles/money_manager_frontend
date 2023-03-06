import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:money_manager/application/boundaries/get_transactions/transaction_dto.dart';

import '../../../domain/value_objects/transaction/value_objects.dart';

extension Iterables<E> on Iterable<E> {
  SplayTreeMap<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
        SplayTreeMap<K, List<E>>(),
        (SplayTreeMap<K, List<E>> map, E element) => map..putIfAbsent(keyFunction(element), () => <E>[]).add(element),
      );
}

class GroupByCategoriesUseCase {
  GroupByCategoriesUseCase();

  SplayTreeMap<Category, List<TransactionDTO>> execute(List<TransactionDTO> transactions) {
    var test = transactions.groupBy((p0) => p0.category);
    // var test = transactions.groupBy((p0) => p0.category.value.fold((l) => '', (r) => r));
    // var output = test.map((key, value) => MapEntry(Category(key), test[key]!.toList()));
    debugPrint(test.toString());
    return test;
  }
}
