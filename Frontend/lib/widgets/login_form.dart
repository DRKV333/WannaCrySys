import 'package:caff_parser/models/enums.dart';
import 'package:caff_parser/models/login_info.dart';
import 'package:caff_parser/providers/auth_provider.dart';
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
  late final AuthProvider _authProvider;

  late TextEditingController _usernameController, _passwordController;

  @override
  void initState() {
    super.initState();

    _authProvider = Provider.of<AuthProvider>(context, listen: false);

    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 48.0),
            child: const GreatBoldText(text: 'Login')),
        BorderedTextField(_usernameController, 'Username', TextInputType.text),
        BorderedTextField(
            _passwordController, 'Password', TextInputType.visiblePassword,
            passwordText: true),
        Consumer<AuthProvider>(
            builder: (context, authProvider, child) =>
                Selector<AuthProvider, bool>(
                  selector: (_, authProvider) => authProvider.isLoading,
                  builder: (_, isLoading, __) => CircularButton(
                    isLoading: isLoading,
                    text: 'Login',
                    onPressed: () async {
                      // TODO: implement login logic
                      await _authProvider.login(LoginInfo(
                          username: _usernameController.text,
                          password: _passwordController.text));
                    },
                  ),
                )),
        CircularButton(
          isLoading: false,
          text: "I don't have an account",
          buttonColor: Colors.white54,
          onPressed: () => _authProvider.changeAuthMode(AuthMode.register),
        )
      ]);
}
