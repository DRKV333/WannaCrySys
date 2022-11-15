import 'package:caff_parser/network/auth_service.dart';
import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/screens/app_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Declare services
  late final AuthService _authService;

  // Declare providers
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();

    // Define services
    _authService = AuthService();

    // Define providers
    _authProvider = AuthProvider(_authService);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Caff Store',
        theme: ThemeData(
          primarySwatch: Colors.lime,
        ),
        home: MultiProvider(
          providers: [
            Provider<AuthService>(create: (_) => _authService),
            ChangeNotifierProvider<AuthProvider>(create: (_) => _authProvider)
          ],
          child: const AppWrapper(),
        ));
  }
}
