import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:money_manager/domain/models/user_model.dart';
import 'package:money_manager/domain/repositories/i_user_repository.dart';
import 'package:money_manager/common/connectivity.dart';
import 'package:money_manager/domain/value_objects/value_failure.dart';
import 'package:money_manager/infrastructure/datasource/i_user_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/constants.dart';
import '../../common/secure_storage.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/value_objects/user/value_objects.dart';
import '../factory/entity_factory.dart';

class UserRepository implements IUserRepository, IAuthRepository {
  final ILocalUserDataSource _localDatasource;
  final EntityFactory _entityFactory;
  UserRepository({required ILocalUserDataSource localDatasource, required EntityFactory entityFactory})
      : _localDatasource = localDatasource,
        _entityFactory = entityFactory;

  @override
  Future<int> addUser(User user) {
    // TODO: implement addUser
    throw UnimplementedError();
  }

  @override
  Future<int> generateUser() async {
    int val = await _localDatasource.generateUser();
    return val;
  }

  @override
  Future<User> get(UserId id) async {
    var val = await _localDatasource.getUser(id);
    return _entityFactory.newUser(
        uid: val.userId, balance: val.balance, expense: val.expense, income: val.income, loggedIn: val.loggedIn);
  }

  @override
  Future<Either<Failure, UserId>> signIn({required Email email, required Password password}) async {
    Dio dio = Dio();
    SecureStorage _secureStorage = SecureStorage();
    String? fE = email.email.fold((l) => null, (r) => r);
    String? fP = password.password.fold((l) => null, (r) => r);
    var map = {
      'email': fE,
      'password': fP
    };
    try {
      var response = await dio.post(
        LOGIN_ENDPOINT,
        data: map,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var body = response.data;
        await _secureStorage.persistEmailAndToken(fE!, body['token'], '1');
        return right(UserId(1));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return left(Failure("Unauthorized"));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
    return left(Failure("Some error occurred"));
  }

  @override
  Future<Either<Failure, UserId>> signUp(
      {required Email email, required Password password, required String name}) async {
    String? fE = email.email.fold((l) => null, (r) => r);
    String? fP = password.password.fold((l) => null, (r) => r);
    Dio dio = Dio();
    var map = {
      'email': fE,
      'password': fP,
      'name': name
    };
    try {
      var response = await dio.post(REGISTER_ENDPOINT, data: map);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var body = response.data;
        return right(UserId(1));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return left(Failure("Unauthorized"));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
    return left(Failure("Some error occurred"));
  }

  Future<void> cleanIfFirstUseAfterUninstall() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("firstTimeLaunch") == null) {
      prefs.setBool("firstTimeLaunch", true);
    }
    final SecureStorage secureStorage = SecureStorage();
    if (prefs.getBool('first_run') ?? true) {
      await _localDatasource.cleanDB();
      await secureStorage.deleteAll();
      await prefs.setBool('first_run', false);
    }
  }
}
