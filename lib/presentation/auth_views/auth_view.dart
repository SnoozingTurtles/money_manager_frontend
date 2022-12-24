import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/domain/value_objects/user/value_objects.dart';
import 'package:money_manager/presentation/bloc/home_bloc/home_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/form/auth_form_bloc.dart';
import '../constants.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key, required this.authState});
  final AuthUnauthenticated authState;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.authState.error.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.authState.error)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
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
  void _submit(AuthFormState form_state) {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (!form_state.signUp) {
      BlocProvider.of<AuthBloc>(context).add(SignInEvent(email: form_state.email, password: form_state.password));
    } else {
      BlocProvider.of<AuthBloc>(context)
          .add(SignUpEvent(email: form_state.email, password: form_state.password, name: 'user'));
    }
    // Navigator.pushNamed(context,'dashboard');
  }

  void _switchAuthMode() {
    BlocProvider.of<AuthFormBloc>(context).add(SwitchAuthEvent());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthFormBloc, AuthFormState>(
      builder: (context, form_state) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0,
          child: Container(
            height: form_state.signUp ? 360 : 300,
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
                      validator: (_) => form_state.email.email.fold((l) => l.message, (r) => null),
                      onChanged: (value) {
                        formKey.currentState!.validate();
                        BlocProvider.of<AuthFormBloc>(context).add(ChangeEmailEvent(email: value));
                      },
                    ),
                    TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        controller: _passwordController,
                        validator: (_) => form_state.password.password.fold((l) => l.message, (r) => null),
                        onChanged: (value) {
                          formKey.currentState!.validate();
                          BlocProvider.of<AuthFormBloc>(context).add(ChangePasswordEvent(password: value));
                        }),
                    if (form_state.signUp)
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
                    ElevatedButton(
                      child: Text(!form_state.signUp ? 'LOGIN' : 'SIGN UP'),
                      onPressed: () => _submit(form_state),
                    ),
                    ElevatedButton(
                      child: Text('SKIP'),
                      onPressed: () => BlocProvider.of<AuthBloc>(context).add(AuthPass()),
                    ),
                    TextButton(
                      child: Text('${!form_state.signUp ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
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
  }
}