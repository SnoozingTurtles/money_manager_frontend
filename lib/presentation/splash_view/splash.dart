import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:money_manager/presentation/dashboard.dart';

import '../constants.dart';
import '../landing_views/landing_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF486C7C),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            if (!state.firstRun) {
              Timer(const Duration(seconds: 5), () => Navigator.of(context).pushReplacementNamed(DashBoard.route));
            } else {
              Timer(const Duration(seconds: 5), () => Navigator.of(context).pushReplacementNamed(LandingPage.route));
            }
          }
        },
        child: Center(
          child: Image.asset(
            "assets/splash_screen/money_manager.gif",
            gaplessPlayback: true,
          ),
        ),
      ),
    );
  }
}
