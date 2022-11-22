import 'dart:collection';

import 'package:money_manager/application/boundaries/get_all_transactions/IGetAllTransactionUseCase.dart';
import 'package:money_manager/application/boundaries/get_all_transactions/get_all_transaction_output.dart';
import 'package:money_manager/application/boundaries/get_all_transactions/transaction_dto.dart';
import 'package:money_manager/domain/repositories/ITransactionRepository.dart';
import 'package:money_manager/infrastructure/model/model.dart';


extension Iterables<E> on Iterable<E> {
  SplayTreeMap<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
    SplayTreeMap<K, List<E>>(),
        (SplayTreeMap<K, List<E>> map, E element) => map..putIfAbsent(keyFunction(element),
            () => <E>[]).add(element),
  );
}

class GetAllTransactionUseCase implements IGetAllTransactionUseCase {
  final ITransactionRepository _transactionRepository;

  GetAllTransactionUseCase({required ITransactionRepository iTransactionRepository})
      : _transactionRepository = iTransactionRepository;

  @override
  Future<GetAllTransactionOutput> execute() async {
    var transactions = await _transactionRepository.getLocal();
    var test = transactions.groupBy((p0) => p0.dateTime.toString().substring(0,10));
    var output =
        test.map((key, value) =>MapEntry(key, test[key]!.map((e) {
          return e is ExpenseModel? ExpenseDTO.fromEntity(e):IncomeDTO.fromEntity(e);
        }).toList()));
    return GetAllTransactionOutput(transactions: SplayTreeMap.from(output));
  }
}
