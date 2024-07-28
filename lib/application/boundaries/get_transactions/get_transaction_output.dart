import 'package:money_manager/application/boundaries/get_transactions/transaction_dto.dart';

class GetAllTransactionOutput {
  final List<TransactionDTO> transactions;

  GetAllTransactionOutput({required this.transactions});
}
