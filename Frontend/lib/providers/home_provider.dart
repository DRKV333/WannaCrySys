import 'package:caff_parser/models/caff_dto.dart';
import 'package:caff_parser/providers/provider_base.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_result.dart';
import '../network/home_service.dart';
import '../utils/globals.dart';
import 'package:flutter/cupertino.dart';

class HomeProvider extends ProviderBase {

  final HomeService _homeService;

  List<CaffDto> caffList = <CaffDto>[];
  final TextEditingController searchController = TextEditingController();

  HomeProvider(this._homeService, SharedPreferences sharedPreferences) : super(sharedPreferences);


  Future<void> getCaffList() async {

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _homeService.getCaffList(token, searchController.text);
      if (apiResult != null) {
        if (apiResult.isSuccess) {
          caffList.clear();
          for(var c in apiResult.data){
            CaffDto temp = CaffDto.fromJson(c as Map<String, dynamic>);
            temp.imgURL = "${Globals.baseIp}/${temp.imgURL.split('\\').join('/')}";
            caffList.add(temp);
          }
          notifyListeners();
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }
  }
}