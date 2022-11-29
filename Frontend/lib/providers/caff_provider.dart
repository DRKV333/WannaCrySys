import 'package:caff_parser/providers/provider_base.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_result.dart';
import '../network/caff_service.dart';
import '../utils/globals.dart';

class CaffProvider extends ProviderBase {

  final CaffService _caffService;

  CaffProvider(this._caffService, SharedPreferences sharedPreferences) : super(sharedPreferences);

  Future<void> getCaff(int caffId) async {

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _caffService.getCaff(token, caffId);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          //
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }
  }

  Future<void> addComment(int caffId, String content) async {

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _caffService.addComment(token, caffId, content);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          //
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }
  }

  Future<void> editComment(int caffId, String content) async {

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _caffService.editComment(token, caffId, content);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          //
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }
  }

  Future<void> deleteComment(int caffId) async {

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _caffService.deleteComment(token, caffId);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          //
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }
  }
}