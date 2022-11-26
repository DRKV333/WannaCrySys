import 'package:flutter/foundation.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProviderBase extends ChangeNotifier {
  final SharedPreferences _sharedPreferences;

  bool _isDisposed = false;

  bool _isLoading = false;

  bool get isDisposed => _isDisposed;
  bool get isLoading => _isLoading;

  ProviderBase(this._sharedPreferences);

  void changeLoadingStatus() {
    _isLoading = !_isLoading;
    if (!_isDisposed) notifyListeners();
  }

  Future<bool> saveToken(String token) async {
    return await _sharedPreferences.setString('token', token);
  }

  Future<bool> removeToken() async {
    return await _sharedPreferences.remove('token');
  }

  String? getToken() {
    return _sharedPreferences.getString('token');
  }

  Future<String?> isLoggedIn() async {
    String? token = getToken();

    if (token == null) return null;

    if (JwtToken.isExpired(token)) {
      await removeToken();
      return null;
    }

    return token;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}