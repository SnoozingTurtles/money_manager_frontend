import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:money_manager/domain/models/user_model.dart';
import 'package:money_manager/domain/repositories/i_user_repository.dart';
import 'package:money_manager/domain/value_objects/value_failure.dart';
import 'package:money_manager/infrastructure/datasource/i_user_data_source.dart';
import 'package:money_manager/infrastructure/datasource/sqlite_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../common/constants.dart';
import '../../common/secure_storage.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/value_objects/user/value_objects.dart';
import '../factory/entity_factory.dart';

class UserRepository implements IUserRepository, IAuthRepository {
  final ILocalUserDataSource _localDatasource;
  final EntityFactory _entityFactory = EntityFactory();

  UserRepository({required Database db}) : _localDatasource = SqliteDataSource(db: db);

  @override
  Future<void> updateUserId({required UserId remoteId}) async {
    await _localDatasource.updateUserId(remoteId: remoteId);
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
        uid: val.localId,
        remoteId: val.remoteId,
        balance: val.balance,
        expense: val.expense,
        income: val.income,
        loggedIn: val.loggedIn);
  }

  @override
  Future<Either<Failure, UserId>> signIn({required Email email, required Password password}) async {
    Dio dio = Dio();
    SecureStorage _secureStorage = SecureStorage();
    String? fE = email.email.fold((l) => null, (r) => r);
    String? fP = password.password.fold((l) => null, (r) => r);
    var map = {'email': fE, 'password': fP};
    try {
      var response = await dio.post(
        LOGIN_ENDPOINT,
        data: map,
      );
      var body = response.data;
      debugPrint("USER REPO: 56: signIn: $body");
      await _secureStorage.persistEmailAndToken(fE!, body['accessToken'], '1', body['refreshToken']);
      return right(UserId(body['userId']));
    } on DioError catch (e) {
      return left(Failure(e.response?.data['message']));
    } catch (e) {
      debugPrint(e.toString());
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserId>> signUp(
      {required Email email, required Password password, required String name}) async {
    String? fE = email.email.fold((l) => null, (r) => r);
    String? fP = password.password.fold((l) => null, (r) => r);
    Dio dio = Dio();
    var map = {'email': fE, 'password': fP, 'name': name};
    try {
      var response = await dio.post(REGISTER_ENDPOINT, data: map);
      debugPrint("USER REPO: 56: signUp: $response");
      return right(UserId(response.data['id']));
    } on DioError catch (e) {
      debugPrint("USER REPO :78 : signUp : error:$e");
      debugPrint(e.response.toString());
      return left(Failure(e.response!.data['message']));
    } catch (e) {
      return left(Failure(e.toString()));
    }
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
