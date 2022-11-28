import 'package:caff_parser/models/enums.dart';
import 'package:caff_parser/models/user_for_registration_dto.dart';
import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/utils/globals.dart';
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
  final GlobalKey<FormState> _registerFormKey = GlobalKey();

  late TextEditingController _nameController,
      _usernameController,
      _passwordController,
      _confirmPasswordController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => Consumer<AuthProvider>(
      builder: (context, authProvider, child) => Form(
            key: _registerFormKey,
            child: Column(children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 48.0),
                  child: const GreatBoldText(text: 'Register')),
              BorderedTextField(
                _nameController,
                'Name',
                TextInputType.name,
                validateFun: Globals.validateName,
              ),
              BorderedTextField(
                _usernameController,
                'Username',
                TextInputType.text,
                validateFun: Globals.validateUsername,
              ),
              BorderedTextField(
                _passwordController,
                'Password',
                TextInputType.visiblePassword,
                passwordText: true,
                validateFun: Globals.validatePassword,
              ),
              BorderedTextField(
                _confirmPasswordController,
                'Confirm password',
                TextInputType.visiblePassword,
                passwordText: true,
                validateFun: (value) => Globals.validateConfirmPassword(
                    value, _passwordController.text),
              ),
              Selector<AuthProvider, bool>(
                selector: (_, authProvider) => authProvider.isLoading,
                builder: (_, isLoading, __) => CircularButton(
                  isLoading: isLoading,
                  text: 'Register',
                  onPressed: () async {
                    if (_registerFormKey.currentState?.validate() ?? false) {
                      bool success = await authProvider.register(
                          UserForRegistrationDto(
                              name: _nameController.text.trim(),
                              username:
                                  _usernameController.text.trim().toLowerCase(),
                              password: _passwordController.text.trim(),
                              confirmPassword:
                                  _confirmPasswordController.text.trim()));
                      if (success) {
                        authProvider.changeAuthMode(AuthMode.login);
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 24.0),
              CircularButton(
                isLoading: false,
                text: 'I have an account',
                buttonColor: Colors.white54,
                onPressed: () => authProvider.changeAuthMode(AuthMode.login),
              )
            ]),
          ));
}
