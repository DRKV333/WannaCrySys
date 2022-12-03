import 'package:caff_parser/models/api_result.dart';
import 'package:caff_parser/network/service_base.dart';
import 'package:dio/dio.dart';

class HomeService extends ServiceBase {

  HomeService() {
    dio.options.baseUrl += '/Caff';
  }

  Future<ApiResult?> getCaffList(String token, String title) async {
    ApiResult? result;
    try {
      Response response = await dio.get('/GetCaffList', queryParameters: {'title': title},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        result = ApiResult(data: response.data);
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }
    return result;
  }
}
