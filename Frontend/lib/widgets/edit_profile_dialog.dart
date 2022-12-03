import 'package:caff_parser/models/user_for_update_dto.dart';
import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/utils/globals.dart';
import 'package:caff_parser/widgets/bordered_text_field.dart';
import 'package:caff_parser/widgets/circular_button.dart';
import 'package:caff_parser/widgets/great_bold_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({Key? key}) : super(key: key);

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final GlobalKey<FormState> _editProfileFormKey = GlobalKey();

  late TextEditingController _nameController,
      _passwordController,
      _confirmPasswordController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  void _navigateBack() => Navigator.of(context).pop(true);

  @override
  Widget build(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          margin: const EdgeInsets.all(24.0),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Consumer<AuthProvider>(
            builder: (_, authProvider, __) => Form(
              key: _editProfileFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const GreatBoldText(
                      text: 'Edit profile',
                    ),
                    BorderedTextField(
                      _nameController,
                      'Name',
                      TextInputType.name,
                      validateFun: Globals.validateName,
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
                        text: 'Save',
                        onPressed: () async {
                          if (_editProfileFormKey.currentState?.validate() ??
                              false) {
                            bool success = await authProvider.editUser(
                                UserForUpdateDto(
                                    name: _nameController.text.trim(),
                                    password: _passwordController.text.trim(),
                                    confirmPassword: _confirmPasswordController
                                        .text
                                        .trim()));
                            if (success) {
                              _navigateBack();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
