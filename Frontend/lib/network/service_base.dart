import 'package:caff_parser/models/api_result.dart';
import 'package:dio/dio.dart';

abstract class ServiceBase {
  late Dio dio;

  ServiceBase() {
    String ip = '192.168.1.69';
    dio = Dio(BaseOptions(
        baseUrl: 'http://$ip:8080', receiveDataWhenStatusError: true));
  }

  ApiResult? handleNetworkError(DioError e) {
    if (e.response != null) {
      return ApiResult(
          isSuccess: false, errorMessage: e.response!.data.toString());
    }

    return null;
  }
}
