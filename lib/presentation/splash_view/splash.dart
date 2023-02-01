import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/presentation/auth_views/auth_view.dart';
import 'package:money_manager/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:money_manager/presentation/dashboard.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoaded) {
              if (!state.firstRun) {
                Navigator.of(context).pushReplacementNamed(DashBoard.route);
              } else {
                Navigator.of(context).pushReplacementNamed(AuthScreen.route);
              }
            }
          },
          child: const Center(child: Text("This page is splash screen ui will be redesigned soon.."))),
    );
  }
}
