import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/common/connectivity.dart';
import 'package:money_manager/common/secure_storage.dart';
import 'package:money_manager/infrastructure/datasource/spring_data_source.dart';
import 'package:money_manager/infrastructure/datasource/sqlite_data_source.dart';
import 'package:money_manager/infrastructure/factory/entity_factory.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';
import 'package:money_manager/presentation/auth_views/auth_view.dart';
import 'package:money_manager/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:money_manager/presentation/bloc/auth_bloc/form/auth_form_bloc.dart';
import 'package:money_manager/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:money_manager/presentation/bloc/transaction_bloc/transaction_bloc.dart';
import 'package:money_manager/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:money_manager/presentation/dashboard.dart';
import 'package:money_manager/presentation/transaction_views/transaction_view.dart';
import 'package:money_manager/presentation/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'infrastructure/factory/db_factory.dart';
import 'infrastructure/repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectivitySingleton _connectivity = ConnectivitySingleton.getInstance();
  _connectivity.initialize();
  final db = await DatabaseFactory().createDatabase();
  bool firstLogin = false;

  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("first_run") == null) {
    firstLogin = true;
  }
  //sync remote to local will be shifted to user login
  BlocOverrides.runZoned(
    () {
      return runApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<EntityFactory>(create: (context) => EntityFactory()),
            RepositoryProvider<UserRepository>(
                create: (context) => UserRepository(
                      localDatasource: SqliteDataSource(db: db),
                      entityFactory: EntityFactory(),
                    )..cleanIfFirstUseAfterUninstall()),
            RepositoryProvider<TransactionRepository>(
                create: (context) => TransactionRepository(
                    secureStorage: SecureStorage(),
                    localDatasource: SqliteDataSource(db: db),
                    connectivity: _connectivity,
                    remoteDatasource: SpringBootDataSource())),
          ],
          child: MultiBlocProvider(
              providers: [
                BlocProvider<UserBloc>(
                  create: (context) => firstLogin
                      ? (UserBloc(userRepository: RepositoryProvider.of<UserRepository>(context))..add(InitUser()))
                      : (UserBloc(userRepository: RepositoryProvider.of<UserRepository>(context))..add(LoadUser())),
                ),
                BlocProvider<AuthBloc>(
                  create: (context) => AuthBloc(
                      RepositoryProvider.of<UserRepository>(context),
                      TransactionRepository(
                        secureStorage: SecureStorage(),
                          localDatasource: SqliteDataSource(db: db),
                          connectivity: _connectivity,
                          remoteDatasource: SpringBootDataSource()),
                    BlocProvider.of<UserBloc>(context),
                  )
                    ..add(AuthInitialEvent()),
                ),
                BlocProvider<HomeBloc>(
                  create: (context) => HomeBloc(
                      transactionRepository: RepositoryProvider.of<TransactionRepository>(context),
                      userBloc: BlocProvider.of<UserBloc>(context)),
                ),
              ],
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                },
                builder: (context, authState) {
                  return MaterialApp(
                    theme: ThemeData(
                      textTheme: mTextTheme,
                    ),
                    home: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                      if (authState is AuthAuthenticated || authState is AuthPassed) {
                        return BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state is UserLoaded)
                              return DashBoard();
                            else
                              return CircularProgressIndicator();
                          },
                        );
                      } else if (authState is AuthLoading) {
                        return CircularProgressIndicator();
                      } else {
                        return BlocProvider<AuthFormBloc>(
                          create: (context) => AuthFormBloc(),
                          child: AuthScreen(authState:authState as AuthUnauthenticated),
                        );
                      }
                    }),
                    routes: {
                      TransactionView.route: (context) {
                        return BlocConsumer<UserBloc, UserState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            if (state is UserLoaded) {
                              return BlocProvider<TransactionBloc>(
                                create: (context) => TransactionBloc(
                                    userBloc: BlocProvider.of<UserBloc>(context),
                                    id: state.user.localId,
                                    iTransactionRepository: RepositoryProvider.of<TransactionRepository>(context),
                                    iEntityFactory: RepositoryProvider.of<EntityFactory>(context)),
                                child: TransactionView(),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        );
                      }
                    },
                  );
                },
              )),
        ),
      );
    },
    blocObserver: MyGlobalObserver(),
  );
}

class MyGlobalObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // debugPrint('${bloc.runtimeType} $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // debugPrint('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
