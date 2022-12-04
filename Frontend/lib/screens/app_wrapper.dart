import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/screens/home_screen.dart';
import 'package:caff_parser/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:jwt_io/jwt_io.dart';
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

    // Trying to login when the app starts
    _authProvider.checkForStoredToken();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<String?>(
      stream: _authProvider.tokenStream,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        String? token = snapshot.data;

        if (token != null) {
          Map<String, dynamic> tokenPayload = JwtToken.payload(token);
          return HomeScreen(username: tokenPayload['username']);
        }
        return const AuthScreen();
      });
}
