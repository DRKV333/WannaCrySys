import 'package:caff_parser/models/enums.dart';
import 'package:caff_parser/models/login_info.dart';
import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/utils/globals.dart';
import 'package:caff_parser/widgets/bordered_text_field.dart';
import 'package:caff_parser/widgets/circular_button.dart';
import 'package:caff_parser/widgets/great_bold_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  late TextEditingController _usernameController, _passwordController;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Consumer<AuthProvider>(
      builder: (context, authProvider, child) => Form(
            key: _loginFormKey,
            child: Column(children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 48.0),
                  child: const GreatBoldText(text: 'Login')),
              BorderedTextField(
                  _usernameController, 'Username', TextInputType.text,
                  validateFun: (value) =>
                      Globals.validateUsername(value, validateRegExp: false)),
              BorderedTextField(
                _passwordController,
                'Password',
                TextInputType.visiblePassword,
                passwordText: true,
                validateFun: (value) =>
                    Globals.validatePassword(value, validateRegExp: false),
              ),
              Selector<AuthProvider, bool>(
                selector: (_, authProvider) => authProvider.isLoading,
                builder: (_, isLoading, __) => CircularButton(
                  isLoading: isLoading,
                  text: 'Login',
                  onPressed: () async {
                    if (_loginFormKey.currentState?.validate() ?? false) {
                      await authProvider.login(LoginInfo(
                          username:
                              _usernameController.text.trim().toLowerCase(),
                          password: _passwordController.text.trim()));
                    }
                  },
                ),
              ),
              CircularButton(
                isLoading: false,
                text: "I don't have an account",
                buttonColor: Colors.white54,
                onPressed: () => authProvider.changeAuthMode(AuthMode.register),
              )
            ]),
          ));
}
