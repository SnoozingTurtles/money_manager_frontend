import 'package:money_manager/application/boundaries/get_transactions/get_transaction_output.dart';

abstract class IGetTransactionUseCase{
  Future<GetAllTransactionOutput> executeAllTime();
  Future<GetAllTransactionOutput> executeThisMonth();
  Future<GetAllTransactionOutput> executeLastMonth();
  Future<GetAllTransactionOutput> executeLast3Months();
  Future<GetAllTransactionOutput> executeLast6Months();
  Future<GetAllTransactionOutput> executeCustom(String startDate, String endDate);
}