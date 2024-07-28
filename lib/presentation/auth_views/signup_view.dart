import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/presentation/auth_views/login_view.dart';
import 'package:money_manager/presentation/auth_views/widgets/widgets.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/form/auth_form_bloc.dart';
import '../bloc/user_bloc/user_bloc.dart';
import '../dashboard.dart';

class SignUpView extends StatelessWidget {
  static const route = '/SignUpView';

  const SignUpView({super.key});

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
              BlocProvider.of<AuthBloc>(context)
                  .add(SignUpEvent(email: state.email, password: state.password, name: state.name));
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
                          child: Text(
                            "Create new account.",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                          child: XField(
                              iconFileName: 'name.png',
                              validator: (_) {
                                return state.name.name.fold((l) => l.message, (r) => null);
                              },
                              onChanged: (value) {
                                BlocProvider.of<AuthFormBloc>(context).add(ChangeNameEvent(name: value));
                              },
                              value: "Name"),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                          child: XField(
                              iconFileName: 'pass.png',
                              validator: (_) {
                                return state.confirmPassword.password.fold((l) => l.message, (r) => null);
                              },
                              onChanged: (value) {
                                BlocProvider.of<AuthFormBloc>(context)
                                    .add(ChangeConfirmPassword(confirmPassword: value));
                              },
                              value: "Confirm Password"),
                        ),
                        state.isValid
                            ? const CircularProgressIndicator()
                            : XButton(
                                onPressed: () {
                                  BlocProvider.of<AuthFormBloc>(context).add(const ValidateSignUp());
                                },
                                alter: false,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 1 / 12,
                                text: "Sign Up",
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(LoginView.route);
                                },
                                child: const Text("Sign In"))
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
