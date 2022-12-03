import 'dart:io';

import 'package:caff_parser/models/api_result.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

abstract class ServiceBase {
  late Dio dio;

  ServiceBase() {
    String ip = '192.168.1.99';
    dio = Dio(BaseOptions(
        baseUrl: 'http://$ip:8080', receiveDataWhenStatusError: true));

    /*(dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };*/
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