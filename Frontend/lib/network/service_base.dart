import 'dart:io';
import 'package:caff_parser/models/api_result.dart';
import 'package:caff_parser/utils/globals.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

abstract class ServiceBase {
  late Dio dio;

  ServiceBase() {
    dio = Dio(BaseOptions(
        baseUrl: Globals.baseIp, receiveDataWhenStatusError: true));

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
  }

  ApiResult? handleNetworkError(DioError e) {
    print(e);
    if (e.response != null) {
      return ApiResult(
          isSuccess: false, errorMessage: e.response!.data.toString());
    }

    return null;
  }
}
