import 'dart:collection';

import 'package:money_manager/application/boundaries/get_all_transactions/transaction_dto.dart';

class GetAllTransactionOutput{
  final UnmodifiableListView<TransactionDTO> transactions;

  GetAllTransactionOutput({required this.transactions});
}