import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/presentation/auth_views/signup_view.dart';
import 'package:money_manager/presentation/auth_views/widgets/widgets.dart';
import 'package:money_manager/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:money_manager/presentation/dashboard.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/form/auth_form_bloc.dart';

class LoginView extends StatelessWidget {
  static const route = '/LoginView';

  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthFormBloc>(
      create: (context) => AuthFormBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            BlocProvider.of<UserBloc>(context).add(LogUserIn(remoteId: state.remoteId));
            Navigator.of(context).pushReplacementNamed(DashBoard.route);
          } else if (state is AuthUnauthenticated) {
            BlocProvider.of<UserBloc>(context).add(InitUser());
            BlocProvider.of<AuthFormBloc>(context).add(const Invalidate());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
        },
        child: BlocConsumer<AuthFormBloc, AuthFormState>(
          listener: (context, state) {
            if (state.isValid) {
              BlocProvider.of<AuthBloc>(context).add(SignInEvent(email: state.email, password: state.password));
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Image.asset('assets/auth_page/cross.png'),
                              onPressed: () {
                                BlocProvider.of<UserBloc>(context).add(InitUser());
                                Navigator.pushReplacementNamed(context, DashBoard.route);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Let's sign you in.",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                            child: Text(
                              "Welcome Back !",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                          child: XField(
                              iconFileName: 'email.png',
                              validator: (_) {
                                return state.email.email.fold((l) => l.message, (r) => null);
                              },
                              onChanged: (value) {
                                BlocProvider.of<AuthFormBloc>(context).add(ChangeEmailEvent(email: value));
                              },
                              value: "Email"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                          child: XField(
                              iconFileName: 'pass.png',
                              validator: (_) {
                                return state.password.password.fold((l) => l.message, (r) => null);
                              },
                              onChanged: (value) {
                                BlocProvider.of<AuthFormBloc>(context).add(ChangePasswordEvent(password: value));
                              },
                              value: "Password"),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                          child: Align(alignment: Alignment.centerRight, child: Text("Forgot Password?")),
                        ),
                        state.isValid
                            ? const CircularProgressIndicator()
                            : XButton(
                                onPressed: () {
                                  BlocProvider.of<AuthFormBloc>(context).add(const ValidateSignIn());
                                },
                                alter: false,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 1 / 12,
                                text: "Login",
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(SignUpView.route);
                                },
                                child: const Text("Sign Up"))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
