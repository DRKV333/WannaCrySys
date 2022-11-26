import 'dart:async';

import 'package:caff_parser/models/api_result.dart';
import 'package:caff_parser/models/enums.dart';
import 'package:caff_parser/models/login_info.dart';
import 'package:caff_parser/models/user_dto.dart';
import 'package:caff_parser/models/user_for_registration_dto.dart';
import 'package:caff_parser/network/auth_service.dart';
import 'package:caff_parser/providers/provider_base.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ProviderBase {
  final AuthService _authService;
  final SharedPreferences _sharedPreferences;

  AuthMode _authMode = AuthMode.login;

  AuthMode get authMode => _authMode;

  final StreamController<String?> _tokenStreamController = StreamController();

  Stream<String?> get tokenStream => _tokenStreamController.stream;

  AuthProvider(this._authService, this._sharedPreferences)
      : super(_sharedPreferences);

  void changeAuthMode(AuthMode authMode) {
    _authMode = authMode;
    if (!isDisposed) notifyListeners();
  }

  String? _getToken() => _sharedPreferences.getString('token');

  Future<bool> _removeToken() async {
    return await _sharedPreferences.remove('token');
  }

  Future<bool> _saveToken(String token) async {
    return await _sharedPreferences.setString('token', token);
  }

  Future<String?> isLoggedIn() async {
    String? token = _getToken();

    if (token == null) return null;

    if (JwtToken.isExpired(token)) {
      await _removeToken();
      return null;
    }

    _tokenStreamController.add(token);
    return token;
  }

  Future<void> login(LoginInfo loginInfo) async {
    changeLoadingStatus();

    ApiResult? apiResult = await _authService.login(loginInfo);

    if (apiResult != null) {
      if (apiResult.isSuccess) {
        String token = apiResult.data as String;

        await _saveToken(token);
        _tokenStreamController.add(token);
      } else {
        // TODO: show toast message
        print(apiResult.errorMessage);
      }
    } else {
      // TODO: show toast message
      print('Something went wrong');
    }

    changeLoadingStatus();
  }

  Future<void> register(UserForRegistrationDto userForRegistrationDto) async {
    changeLoadingStatus();

    ApiResult? apiResult = await _authService.register(userForRegistrationDto);

    if (apiResult != null) {
      if (apiResult.isSuccess) {
        // TODO: show toast message
        print('Successful registration');
      } else {
        // TODO: show toast message
        print(apiResult.errorMessage);
      }
    } else {
      // TODO: show toast message
      print('Something went wrong');
    }

    changeLoadingStatus();
  }

  Future<void> logout() async {
    await _removeToken();
    _tokenStreamController.add(null);
  }

  Future<UserDto?> getCurrentUser() async {
    UserDto? userDto;

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _authService.getCurrentUser(token);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          userDto = UserDto.fromJson(apiResult.data as Map<String, dynamic>);
        } else {
          // TODO: show toast message
          print(apiResult.errorMessage);
        }
      } else {
        // TODO: show toast message
        print('Something went wrong');
      }
    }

    return userDto;
  }
}
