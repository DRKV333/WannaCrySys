import 'package:caff_parser/network/base_service.dart';
import 'package:dio/dio.dart';

class MainService extends BaseService {
  MainService() {
    dio.options.baseUrl += '/Caff';
    dio.options.headers["accept"] = "text/plain";
  }

  Future<void> getCaffList() async {
    try {
      print("teszt");
      Response response = await dio.get("/GetCaffList/");
      print(response.data.toString());
      await Future.delayed(const Duration(milliseconds: 500));
    } on DioError catch (e) {
      print(e);
      //handleNetworkError(e);
    }
  }
}