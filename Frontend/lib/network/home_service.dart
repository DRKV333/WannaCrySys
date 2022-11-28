import 'package:caff_parser/models/api_result.dart';
import 'package:caff_parser/models/login_info.dart';
import 'package:caff_parser/models/user_for_registration_dto.dart';
import 'package:caff_parser/network/service_base.dart';
import 'package:dio/dio.dart';

class HomeService extends ServiceBase {
  HomeService() {
    dio.options.baseUrl += '/Caff';
  }

  Future<ApiResult?> getCaffList(String token) async {
    ApiResult? result;
    try {
      Response response = await dio.get('/GetCaffList',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      print(response.statusCode);
      if (response.statusCode == 200) {
        result = ApiResult();
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }
    return result;
  }
}