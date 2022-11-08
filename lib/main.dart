import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/bloc/home_bloc/home_bloc.dart';
import 'package:money_manager/bloc/transaction_bloc/transaction_bloc.dart';
import 'package:money_manager/infrastructure/repository/model_repository.dart';
import 'package:money_manager/presentation/dashboard.dart';
import 'package:money_manager/presentation/transaction_views/transaction_view.dart';
import 'package:money_manager/presentation/theme.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ModelRepository(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(textTheme: mTextTheme),
        home: MultiBlocProvider(providers: [
          BlocProvider<HomeBloc>(
            create: (context) =>
                HomeBloc(RepositoryProvider.of<ModelRepository>(context)),
          )
        ], child: const DashBoard()),
        routes: {
          TransactionView.route: (context) {
            return BlocProvider<TransactionBloc>(
              create: (context) => TransactionBloc(
                  RepositoryProvider.of<ModelRepository>(context)),
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
