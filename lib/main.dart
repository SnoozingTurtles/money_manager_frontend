import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/common/connectivity.dart';
import 'package:money_manager/infrastructure/datasource/spring_data_source.dart';
import 'package:money_manager/infrastructure/datasource/sqlite_data_source.dart';
import 'package:money_manager/infrastructure/factory/entity_factory.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';
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
  final prefs = await SharedPreferences.getInstance();
  bool firstLogin = false;
  if (prefs.getBool("firstTimeLaunch") == null) {
    print("first run");
    prefs.setBool("firstTimeLaunch", true);
    firstLogin = true;
  }
  //sync remote to local will be shifted to user login
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => EntityFactory()),
        RepositoryProvider(
            create: (context) =>
                UserRepository(localDatasource: SqliteDataSource(db: db), entityFactory: EntityFactory())),
        RepositoryProvider(
            create: (context) => TransactionRepository(
                localDatasource: SqliteDataSource(db: db),
                connectivity: _connectivity,
                remoteDatasource: SpringBootDataSource())),
      ],
      child: BlocProvider(
        create: (context) => firstLogin
            ? (UserBloc(userRepository: RepositoryProvider.of<UserRepository>(context))..add(InitUser()))
            : (UserBloc(userRepository: RepositoryProvider.of<UserRepository>(context))..add(LoadUser())),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoaded) {
              print("state is loaded ${state.user.balance}");
            }
          },
          builder: (context, state) {
            if (state is UserLoaded) {
              return MaterialApp(
                theme: ThemeData(
                  textTheme: mTextTheme,
                ),
                home: BlocProvider<HomeBloc>(
                    create: (context) => HomeBloc(
                        transactionRepository: RepositoryProvider.of<TransactionRepository>(context),
                        userBloc: BlocProvider.of<UserBloc>(context)),
                    child: const DashBoard()),
                routes: {
                  TransactionView.route: (context) {
                    return BlocProvider<TransactionBloc>(
                      create: (context) => TransactionBloc(
                          userBloc: BlocProvider.of<UserBloc>(context),
                          id: state.user.userId,
                          iTransactionRepository: RepositoryProvider.of<TransactionRepository>(context),
                          iEntityFactory: RepositoryProvider.of<EntityFactory>(context)),
                      child: TransactionView(),
                    );
                  }
                },
              );
            } else {
              return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
            }
          },
        ),
      ),
    ),
  );
  SimpleBlocObserver observer = SimpleBlocObserver();
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}
