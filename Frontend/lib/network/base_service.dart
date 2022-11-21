import 'package:dio/dio.dart';

abstract class BaseService {
  late Dio dio;

  BaseService() {
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
  }

  void handleNetworkError(DioError e) {
    // TODO: handle network error
  }
}