import 'dart:collection';

import 'package:money_manager/application/boundaries/get_transactions/transaction_dto.dart';

class GetAllTransactionOutput{
  final SplayTreeMap<String,List<TransactionDTO>> transactions;

  GetAllTransactionOutput({required this.transactions});
}