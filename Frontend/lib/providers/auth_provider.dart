import 'dart:async';

import 'package:caff_parser/models/api_result.dart';
import 'package:caff_parser/models/enums.dart';
import 'package:caff_parser/models/login_info.dart';
import 'package:caff_parser/models/user_dto.dart';
import 'package:caff_parser/models/user_for_registration_dto.dart';
import 'package:caff_parser/network/auth_service.dart';
import 'package:caff_parser/providers/provider_base.dart';
import 'package:caff_parser/utils/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ProviderBase {
  final AuthService _authService;

  AuthMode _authMode = AuthMode.login;

  AuthMode get authMode => _authMode;

  final StreamController<String?> _tokenStreamController = StreamController();

  Stream<String?> get tokenStream => _tokenStreamController.stream;

  AuthProvider(this._authService, SharedPreferences sharedPreferences)
      : super(sharedPreferences);

  void changeAuthMode(AuthMode authMode) {
    _authMode = authMode;
    if (!isDisposed) notifyListeners();
  }

  Future<void> checkForStoredToken() async {
    String? token = await isLoggedIn();

    if (token != null) {
      _tokenStreamController.add(token);
    }
  }

  Future<void> login(LoginInfo loginInfo) async {
    changeLoadingStatus();

    ApiResult? apiResult = await _authService.login(loginInfo);

    if (apiResult != null) {
      if (apiResult.isSuccess) {
        String token = apiResult.data as String;

        await saveToken(token);
        _tokenStreamController.add(token);
      } else {
        Globals.showMessage(apiResult.errorMessage!, true);
      }
    } else {
      Globals.showMessage('Something went wrong', true);
    }

    changeLoadingStatus();
  }

  Future<void> register(UserForRegistrationDto userForRegistrationDto) async {
    changeLoadingStatus();

    ApiResult? apiResult = await _authService.register(userForRegistrationDto);

    if (apiResult != null) {
      if (apiResult.isSuccess) {
        Globals.showMessage('Successful registration');
      } else {
        Globals.showMessage(apiResult.errorMessage!, true);
      }
    } else {
      Globals.showMessage('Something went wrong', true);
    }

    changeLoadingStatus();
  }

  Future<void> logout() async {
    await removeToken();
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
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }

    return userDto;
  }
}
