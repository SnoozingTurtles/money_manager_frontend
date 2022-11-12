import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/infrastructure/datasource/spring_data_source.dart';
import 'package:money_manager/infrastructure/datasource/sqlite_data_source.dart';
import 'package:money_manager/infrastructure/factory/entity_factory.dart';
import 'package:money_manager/infrastructure/repository/fake/FakeTransactionRepository.dart';
import 'package:money_manager/infrastructure/repository/model_repository.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';
import 'package:money_manager/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:money_manager/presentation/bloc/transaction_bloc/transaction_bloc.dart';
import 'package:money_manager/presentation/dashboard.dart';
import 'package:money_manager/presentation/transaction_views/transaction_view.dart';
import 'package:money_manager/presentation/theme.dart';

import 'infrastructure/factory/db_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await DatabaseFactory().createDatabase();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => FakeTransactionRepository()),
        RepositoryProvider(create: (context) => EntityFactory()),
        // RepositoryProvider(create: (context) => TransactionRepository(datasource: SqliteDataSource(db: db))),
        RepositoryProvider(create: (context) => TransactionRepository(datasource: SpringBootDataSource())),
      ],
      child: MaterialApp(
        theme: ThemeData(textTheme: mTextTheme),
        home: MultiBlocProvider(providers: [
          BlocProvider<HomeBloc>(
            create: (context) =>
                HomeBloc(iTransactionRepository: RepositoryProvider.of<TransactionRepository>(context)),
          )
        ], child: const DashBoard()),
        routes: {
          TransactionView.route: (context) {
            return BlocProvider<TransactionBloc>(
              create: (context) => TransactionBloc(
                  iTransactionRepository: RepositoryProvider.of<TransactionRepository>(context),
                  iEntityFactory: RepositoryProvider.of<EntityFactory>(context)),
              child: TransactionView(),
            );
          }
        },
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
