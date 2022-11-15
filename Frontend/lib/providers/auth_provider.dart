import 'dart:async';

import 'package:caff_parser/models/enums.dart';
import 'package:caff_parser/models/login_info.dart';
import 'package:caff_parser/models/user_dto.dart';
import 'package:caff_parser/models/user_for_registration_dto.dart';
import 'package:caff_parser/network/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  bool _isDisposed = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  AuthMode _authMode = AuthMode.login;

  AuthMode get authMode => _authMode;

  final StreamController<UserDto?> _userController = StreamController();

  Stream<UserDto?> get userStream => _userController.stream;

  AuthProvider(this._authService);

  void changeLoadingStatus() {
    _isLoading = !_isLoading;
    if (!_isDisposed) notifyListeners();
  }

  void changeAuthMode(AuthMode authMode) {
    _authMode = authMode;
    if (!_isDisposed) notifyListeners();
  }

  Future<void> login(LoginInfo loginInfo) async {
    // TODO: implement login logic
    changeLoadingStatus();
    await _authService.login(loginInfo);
    _userController.add(UserDto(id: -1, username: loginInfo.username));
    changeLoadingStatus();
  }

  Future<void> register(UserForRegistrationDto userForRegistrationDto) async {
    // TODO: implement register logic
    changeLoadingStatus();
    await _authService.register(userForRegistrationDto);
    changeLoadingStatus();
  }

  Future<void> logout() async {
    _userController.add(null);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
