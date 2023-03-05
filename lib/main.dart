import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/infrastructure/repository/transaction_repository.dart';
import 'package:money_manager/infrastructure/repository/user_repository.dart';
import 'package:money_manager/presentation/auth_views/login_view.dart';
import 'package:money_manager/presentation/auth_views/signup_view.dart';
import 'package:money_manager/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:money_manager/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:money_manager/presentation/dashboard.dart';
import 'package:money_manager/presentation/landing_views/landing_page.dart';
import 'package:money_manager/presentation/splash_view/splash.dart';

import 'package:money_manager/presentation/transaction_views/transaction_form_view.dart';
import 'package:sqflite/sqflite.dart' as sql;

import 'infrastructure/factory/db_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sql.Database db = await DatabaseFactory().createDatabase();
  BlocOverrides.runZoned(
    () {
      return runApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider(create: (context) => TransactionRepository(db: db)),
            RepositoryProvider(create: (context) => UserRepository(db: db)),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<UserBloc>(
                create: (context) => UserBloc(
                  userRepository: RepositoryProvider.of<UserRepository>(context),
                )..add(InitUser()),
              ),
              BlocProvider<AuthBloc>(
                create: (context) => AuthBloc(
                  transactionRepository: RepositoryProvider.of<TransactionRepository>(context),
                  userRepository: RepositoryProvider.of<UserRepository>(context),
                ),
              ),
            ],
            child: MaterialApp(
              home: SplashScreen(),
              routes: {
                DashBoard.route: (context) => const DashBoard(),
                SignUpView.route: (context) =>  SignUpView(),
                LoginView.route:(context) => LoginView(),
                TransactionFormView.route: (context) => const TransactionFormView(),
                LandingPage.route: (context) => const LandingPage(),
              },
              theme: ThemeData(
                primaryColor: Color(0xFF486C7C),
                textTheme: const TextTheme(
                  displayLarge: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: Color(0XFF04021D),
                  ),
                  titleLarge: TextStyle(fontSize: 30.0, fontFamily: 'Poppins'),
                  bodyMedium: TextStyle(fontSize: 16.0, fontFamily: 'Poppins'),
                  bodySmall: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
                ),
              ),
            ),
          ),
        ),
      );
    },
    blocObserver: MyGlobalObserver(),
  );
}

class MyGlobalObserver extends BlocObserver {
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
