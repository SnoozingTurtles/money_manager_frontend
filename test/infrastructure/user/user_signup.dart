import 'package:flutter_test/flutter_test.dart';
import 'package:money_manager/infrastructure/datasource/spring_data_source.dart';
import 'package:money_manager/infrastructure/datasource/sqlite_data_source.dart';
import 'package:money_manager/infrastructure/factory/entity_factory.dart';
import 'package:money_manager/infrastructure/repository/user_repository.dart';

import '../repository/transaction_repository_test.mocks.dart';

void main() {
  db _db = db();
  UserRepository userRepository = UserRepository(
      localDatasource: SqliteDataSource(db: _db),
      remoteDataSource: SpringBootDataSource(),
      entityFactory: EntityFactory());
  group('sign user', () {
    test('sign user up success', () async {
      var id = await userRepository.signUp('testfromtest@gmail.com', 'test', 'password');
      expect(id.fold((l) => l, (r) => r.value), equals(1));
    });
    test('sign in user returns token', () async {
      var id = await userRepository.signIn('abc@gmail.com', 'test');
      expect(id.fold((l) => l, (r) => r.value),equals(1));
    });
  });
}
