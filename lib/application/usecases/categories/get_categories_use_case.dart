import 'package:money_manager/application/usecases/categories/group_categories_use_case.dart';

import '../../../domain/value_objects/transaction/value_objects.dart';
import '../../boundaries/get_transactions/transaction_dto.dart';

class GetCategoriesUseCase extends GroupByCategoriesUseCase {
  GetCategoriesUseCase() : super();

  Set<Category> getCategories(List<TransactionDTO> transactions) {
    var output = super.execute(transactions);
    return output.keys.toSet();
  }
}
