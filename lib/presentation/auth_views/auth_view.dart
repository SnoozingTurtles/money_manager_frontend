import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/domain/value_objects/user/value_objects.dart';
import 'package:money_manager/presentation/bloc/home_bloc/home_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/form/auth_form_bloc.dart';
import '../constants.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: height,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: AuthCard(key: GlobalKey<FormState>()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
   AuthCard({
    required Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _passwordController = TextEditingController();
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void _submit(AuthState auth_state,AuthFormState form_state) {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (auth_state is AuthSignIn) {
      print('going sign in');
      BlocProvider.of<AuthBloc>(context).add(SignInEvent(email: form_state.email, password:form_state.password));
    } else {
      print('going sign up');
      BlocProvider.of<AuthBloc>(context)
          .add(SignUpEvent(email: form_state.email, password:form_state.password, name: 'user'));
    }
    // Navigator.pushNamed(context,'dashboard');
  }

  void _switchAuthMode() {
    BlocProvider.of<AuthBloc>(context).add(SwitchAuthEvent());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthFormBloc, AuthFormState>(
      listener: (context, form_state) {
        // TODO: implement listener
      },
      builder: (context, form_state) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, auth_state) {
            print("auth form state is $auth_state");
          },
          builder: (context, auth_state) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 8.0,
              child: Container(
                height: auth_state is AuthSignUp ? 360 : 300,
                width: width! * 0.75,
                padding: EdgeInsets.all(16.0),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: 'E-Mail'),
                          keyboardType: TextInputType.emailAddress,
                          validator:(_)=> form_state.email.email.fold((l) => l.message, (r) => null),
                          onChanged: (value){
                            formKey.currentState!.validate();
                            BlocProvider.of<AuthFormBloc>(context).add(ChangeEmailEvent(email: value));
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          controller: _passwordController,
                          validator: (_)=> form_state.password.password.fold((l) => l.message, (r) => null),
                          onChanged: (value){
                            formKey.currentState!.validate();
                            BlocProvider.of<AuthFormBloc>(context).add(ChangePasswordEvent(password: value));
                          }
                        ),
                        if (auth_state is AuthSignUp)
                          TextFormField(
                              decoration: InputDecoration(labelText: 'Confirm Password'),
                              obscureText: true,
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                              }),
                        SizedBox(
                          height: 20,
                        ),
                        if (auth_state is AuthLoading)
                          CircularProgressIndicator()
                        else
                          ElevatedButton(
                            child: Text(auth_state is AuthSignIn ? 'LOGIN' : 'SIGN UP'),
                            onPressed: () => _submit(auth_state,form_state),
                          ),ElevatedButton(
                            child: Text('SKIP'),
                            onPressed: () => BlocProvider.of<AuthBloc>(context).add(AuthPass()),
                          ),
                        TextButton(
                          child: Text('${auth_state is AuthSignIn ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                          onPressed: _switchAuthMode,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
