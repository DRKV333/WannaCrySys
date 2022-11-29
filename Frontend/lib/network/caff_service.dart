import 'package:caff_parser/models/api_result.dart';
import 'package:caff_parser/network/service_base.dart';
import 'package:dio/dio.dart';

class CaffService extends ServiceBase {
  CaffService() {
    dio.options.baseUrl += '/Caff';
  }

  Future<ApiResult?> getCaff(String token, int caffId) async {
    ApiResult? result;
    try {
      Response response = await dio.get('/GetCaff', queryParameters: {"caffId": caffId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        result = ApiResult(data: response.data);
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }
    return result;
  }

  Future<ApiResult?> addComment(String token, int caffId, String content) async {
    ApiResult? result;
    try {
      Response response = await dio.post('/AddComment', queryParameters: {"caffId": caffId, "content": content},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        result = ApiResult();
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }
    return result;
  }

  Future<ApiResult?> editComment(String token, int commentId, String content) async {
    ApiResult? result;
    try {
      Response response = await dio.put('/EditComment', queryParameters: {"commentId": commentId, "content": content},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        result = ApiResult();
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }
    return result;
  }

  Future<ApiResult?> deleteComment(String token, int commentId) async {
    ApiResult? result;
    try {
      Response response = await dio.delete('/DeleteComment', queryParameters: {"commentId": commentId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        result = ApiResult();
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }
    return result;
  }
}