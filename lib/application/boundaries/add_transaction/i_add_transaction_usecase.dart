import 'package:money_manager/application/boundaries/i_usecase.dart';
import 'package:money_manager/application/boundaries/add_transaction/add_transaction_input.dart';
import 'package:money_manager/application/boundaries/add_transaction/add_transaction_output.dart';

abstract class IAddTransactionUseCase extends IUseCase<AddTransactionInput,AddTransactionOutput>{}