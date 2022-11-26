import 'package:caff_parser/models/api_result.dart';
import 'package:caff_parser/models/login_info.dart';
import 'package:caff_parser/models/user_for_registration_dto.dart';
import 'package:caff_parser/network/service_base.dart';
import 'package:dio/dio.dart';

class AuthService extends ServiceBase {
  AuthService() {
    dio.options.baseUrl += '/Auth';
  }

  Future<ApiResult?> login(LoginInfo loginInfo) async {
    ApiResult? result;

    try {
      Response response = await dio.post('/Login', data: loginInfo.toJson());

      if (response.statusCode == 200) {
        result = ApiResult(data: response.data);
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }

    return result;
  }

  Future<ApiResult?> register(
      UserForRegistrationDto userForRegistrationDto) async {
    ApiResult? result;

    try {
      Response response =
          await dio.post('/Register', data: userForRegistrationDto.toJson());

      if (response.statusCode == 201) {
        result = ApiResult();
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }

    return result;
  }

  Future<ApiResult?> getCurrentUser(String token) async {
    ApiResult? result;

    try {
      Response response = await dio.get('/GetUser',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 201) {
        result = ApiResult();
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }

    return result;
  }
}
