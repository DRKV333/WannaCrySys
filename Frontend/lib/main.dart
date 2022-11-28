import 'package:caff_parser/network/auth_service.dart';
import 'package:caff_parser/providers/auth_provider.dart';
import 'package:caff_parser/providers/home_provider.dart';
import 'package:caff_parser/screens/app_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network/home_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({Key? key, required this.sharedPreferences}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Declare services
  late final AuthService _authService;
  late final HomeService _homeService;

  // Declare providers
  late final AuthProvider _authProvider;
  late final HomeProvider _homeProvider;

  @override
  void initState() {
    super.initState();

    // Define services
    _authService = AuthService();
    _homeService = HomeService();

    // Define providers
    _authProvider = AuthProvider(_authService, widget.sharedPreferences);
    _homeProvider = HomeProvider(_homeService, widget.sharedPreferences);
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
            ChangeNotifierProvider<AuthProvider>(create: (_) => _authProvider),
            Provider<HomeService>(create: (_) => _homeService),
            ChangeNotifierProvider<HomeProvider>(create: (_) => _homeProvider)
          ],
          child: const AppWrapper(),
        ));
  }
}
