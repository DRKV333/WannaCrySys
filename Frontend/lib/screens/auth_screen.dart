import 'package:caff_parser/models/enums.dart';
import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/widgets/login_form.dart';
import 'package:caff_parser/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black38, width: 2.0),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) => SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Selector<AuthProvider, AuthMode>(
                  selector: (_, authProvider) => authProvider.authMode,
                  builder: (_, authMode, __) => authMode == AuthMode.login
                      ? const LoginForm()
                      : const RegisterForm(),
                ),
              ),
            ),
          ),
        ),
      );
}
