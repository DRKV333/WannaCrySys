import 'package:caff_parser/providers/provider_base.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_result.dart';
import '../network/home_service.dart';
import '../utils/globals.dart';

class HomeProvider extends ProviderBase {

  final HomeService _homeService;
  List<ApiResult> CaffList = <ApiResult>[];

  HomeProvider(this._homeService, SharedPreferences sharedPreferences) : super(sharedPreferences);

  String test = "";

  Future<void> getCaffList() async {

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _homeService.getCaffList(token);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          test = "GOOD";
          notifyListeners();
          //userDto = UserDto.fromJson(apiResult.data as Map<String, dynamic>);
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }
  }
}