import 'package:caff_parser/models/enums.dart';
import 'package:caff_parser/models/user_for_registration_dto.dart';
import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/widgets/bordered_text_field.dart';
import 'package:caff_parser/widgets/circular_button.dart';
import 'package:caff_parser/widgets/great_bold_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late final AuthProvider _authProvider;

  late TextEditingController _nameController,
      _usernameController,
      _passwordController,
      _confirmPasswordController;

  @override
  void initState() {
    super.initState();

    _authProvider = Provider.of<AuthProvider>(context, listen: false);

    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 48.0),
            child: const GreatBoldText(text: 'Register')),
        BorderedTextField(_nameController, 'Name', TextInputType.name),
        BorderedTextField(_usernameController, 'Username', TextInputType.text),
        BorderedTextField(
            _passwordController, 'Password', TextInputType.visiblePassword,
            passwordText: true),
        BorderedTextField(_confirmPasswordController, 'Confirm password',
            TextInputType.visiblePassword,
            passwordText: true),
        Consumer<AuthProvider>(
            builder: (context, authProvider, child) =>
                Selector<AuthProvider, bool>(
                  selector: (_, authProvider) => authProvider.isLoading,
                  builder: (_, isLoading, __) => CircularButton(
                    isLoading: isLoading,
                    text: 'Register',
                    onPressed: () async {
                      // TODO: implement register logic
                      await _authProvider.register(UserForRegistrationDto(
                          name: _nameController.text,
                          username: _usernameController.text,
                          password: _passwordController.text,
                          confirmPassword: _confirmPasswordController.text));
                    },
                  ),
                )),
        const SizedBox(height: 24.0),
        CircularButton(
          isLoading: false,
          text: 'I have an account',
          buttonColor: Colors.white54,
          onPressed: () => _authProvider.changeAuthMode(AuthMode.login),
        )
      ]);
}
