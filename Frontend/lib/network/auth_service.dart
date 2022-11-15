import 'package:caff_parser/models/login_info.dart';
import 'package:caff_parser/models/user_for_registration_dto.dart';
import 'package:caff_parser/network/base_service.dart';
import 'package:dio/dio.dart';

class AuthService extends BaseService {
  AuthService() {
    dio.options.baseUrl += '/Auth';
  }

  Future<void> login(LoginInfo loginInfo) async {
    try {
      // TODO: implement login endpoint call
      await Future.delayed(const Duration(milliseconds: 500));
    } on DioError catch (e) {
      handleNetworkError(e);
    }
  }

  Future<void> register(UserForRegistrationDto userForRegistrationDto) async {
    try {
      // TODO: implement register endpoint call
      await Future.delayed(const Duration(milliseconds: 500));
    } on DioError catch (e) {
      handleNetworkError(e);
    }
  }
}
