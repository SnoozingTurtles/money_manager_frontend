import 'package:money_manager/application/boundaries/get_all_transactions/get_all_transaction_output.dart';

abstract class IGetAllTransactionUseCase{
  Future<GetAllTransactionOutput> execute();
}