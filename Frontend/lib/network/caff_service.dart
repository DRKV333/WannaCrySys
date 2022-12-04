import 'dart:io';

import 'package:caff_parser/models/api_result.dart';
import 'package:caff_parser/network/service_base.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class CaffService extends ServiceBase {
  CaffService() {
    dio.options.baseUrl += '/Caff';
  }

  Future<ApiResult?> createCaff(
      String token, MultipartFile caffFile, String title) async {
    ApiResult? result;
    try {
      FormData formData = FormData.fromMap({
        'Title': title,
      });
      formData.files.add(MapEntry('CaffFile', caffFile));
      Response response = await dio.post('/AddNewCaff',
          data: formData,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 201) {
        result = ApiResult();
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }
    return result;
  }

  Future<ApiResult?> editCaff(
      String token, int caffId, MultipartFile? caffFile, String title) async {
    ApiResult? result;
    try {
      FormData formData = FormData.fromMap({
        'Title': title,
      });

      if (caffFile != null) {
        formData.files.add(MapEntry('CaffFile', caffFile));
      }

      Response response = await dio.put('/EditCaff',
          queryParameters: {'caffId': caffId},
          data: formData,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 204) {
        result = ApiResult();
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }
    return result;
  }

  Future<ApiResult?> getCaff(String token, int caffId) async {
    ApiResult? result;
    try {
      Response response = await dio.get('/GetCaff',
          queryParameters: {"caffId": caffId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        result = ApiResult(data: response.data);
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }
    return result;
  }

  Future<ApiResult?> deleteCaff(String token, int caffId) async {
    ApiResult? result;
    try {
      Response response = await dio.delete('/DeleteCaff',
          queryParameters: {"caffId": caffId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 204) {
        result = ApiResult(data: response.data);
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }
    return result;
  }

  Future<ApiResult?> purchaseCaff(String token, int caffId) async {
    ApiResult? result;
    try {
      Response response = await dio.post('/PurchaseCaff',
          queryParameters: {"caffId": caffId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 204) {
        result = ApiResult(data: response.data);
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }
    return result;
  }

  Future<ApiResult?> downloadCaff(
      String token, int caffId, String title) async {
    ApiResult? result;
    try {
      Directory downloadDir = (await getExternalStorageDirectory())!;
      String filePath = "${downloadDir.path}/$title.caff";
      Response response = await dio.download(
          '/DownloadCaffFile', filePath,
          queryParameters: {"caffId": caffId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        result = ApiResult(data: filePath);
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }
    return result;
  }

  Future<ApiResult?> addComment(
      String token, int caffId, String content) async {
    ApiResult? result;
    try {
      Response response = await dio.post('/AddComment',
          queryParameters: {"caffId": caffId, "content": content},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 201) {
        result = ApiResult(data: response.data);
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }
    return result;
  }

  Future<ApiResult?> editComment(
      String token, int commentId, String content) async {
    ApiResult? result;
    try {
      Response response = await dio.put('/EditComment',
          queryParameters: {"commentId": commentId, "content": content},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 204) {
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
      Response response = await dio.delete('/DeleteComment',
          queryParameters: {"commentId": commentId},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 204) {
        result = ApiResult();
      }
    } on DioError catch (e) {
      result = handleNetworkError(e);
    }
    return result;
  }
}
