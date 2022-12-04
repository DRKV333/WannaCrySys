import 'dart:async';

import 'package:caff_parser/models/api_result.dart';
import 'package:caff_parser/models/enums.dart';
import 'package:caff_parser/models/login_info.dart';
import 'package:caff_parser/models/user_dto.dart';
import 'package:caff_parser/models/user_for_registration_dto.dart';
import 'package:caff_parser/models/user_for_update_dto.dart';
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

  UserDto? _userDto;

  UserDto? get userDto => _userDto;

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

  Future<bool> register(UserForRegistrationDto userForRegistrationDto) async {
    bool success = false;
    changeLoadingStatus();

    ApiResult? apiResult = await _authService.register(userForRegistrationDto);

    if (apiResult != null) {
      if (apiResult.isSuccess) {
        Globals.showMessage('Successful registration');
        success = true;
      } else {
        Globals.showMessage(apiResult.errorMessage!, true);
      }
    } else {
      Globals.showMessage('Something went wrong', true);
    }

    changeLoadingStatus();
    return success;
  }

  Future<void> logout() async {
    await removeToken();
    _tokenStreamController.add(null);
  }

  Future<void> getCurrentUser() async {
    changeLoadingStatus();

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _authService.getCurrentUser(token);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          _userDto = UserDto.fromJson(apiResult.data as Map<String, dynamic>);
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }

    changeLoadingStatus();
  }

  Future<bool> editUser(UserForUpdateDto userDto) async {
    changeLoadingStatus();

    bool success = false;

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _authService.editUser(token, userDto);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          success = true;
          Globals.showMessage('Profile edited successfully');
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }

    changeLoadingStatus();
    return success;
  }
}
