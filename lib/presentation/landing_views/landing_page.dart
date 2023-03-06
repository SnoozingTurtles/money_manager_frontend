import 'package:flutter/material.dart';
import 'package:money_manager/presentation/auth_views/login_view.dart';
import 'package:money_manager/presentation/constants.dart';
import 'package:money_manager/presentation/dashboard.dart';

import '../auth_views/signup_view.dart';

class LandingPage extends StatelessWidget {
  static const route = "/LandingPage";
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all((width! / height!) * 50),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/landing_screen/landing_page.png",
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Explore an authentic way of tracking expenses ",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Keep track of all your expenditures, budgets, bill splits all in one place.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "View, sort and categorize all expenses, watch out for over all stats, notify people you have paid for.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          XButton(
                            text: "Sign Up",
                            alter: false,
                            width: 160,
                            height: 50,
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(SignUpView.route);
                            },
                          ),
                          XButton(
                            text: "Log In",
                            alter: true,
                            width: 160,
                            height: 50,
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(LoginView.route);
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: XButton(
                            text: ("Skip"),
                            alter: false,
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(DashBoard.route);
                            },
                            width: 75,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class XButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final bool alter;
  final void Function() onPressed;
  const XButton({
    required this.onPressed,
    required this.alter,
    required this.width,
    required this.height,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        foregroundColor: alter ? Theme.of(context).primaryColor : Color(0xFFF2DA0E),
        backgroundColor: alter ? Colors.white : Theme.of(context).primaryColor,
      ),
      child: Text(text),
      onPressed: onPressed,
    );
  }
}
