import 'package:caff_parser/models/user_dto.dart';
import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/screens/home_screen.dart';
import 'package:caff_parser/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();

    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: _authProvider.userStream,
      builder: (BuildContext context, AsyncSnapshot<UserDto?> snapshot) {
        UserDto? userDto = snapshot.data;

        if (userDto != null) {
          return HomeScreen(userDto: userDto);
        }

        return const AuthScreen();
      }
  );
}
