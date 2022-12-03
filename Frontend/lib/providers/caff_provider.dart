import 'package:caff_parser/providers/provider_base.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caff_parser/models/api_result.dart';
import 'package:caff_parser/network/caff_service.dart';
import 'package:caff_parser/utils/globals.dart';
import 'package:file_picker/file_picker.dart';

class CaffProvider extends ProviderBase {
  final CaffService _caffService;

  CaffProvider(this._caffService, SharedPreferences sharedPreferences)
      : super(sharedPreferences);

  Future<bool> createCaff(PlatformFile caffFile, String title) async {
    changeLoadingStatus();

    MultipartFile caffMultipartFile =
        MultipartFile.fromBytes(caffFile.bytes!, filename: caffFile.name);

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult =
          await _caffService.createCaff(token, caffMultipartFile, title);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          Globals.showMessage('Caff file uploaded successfully');
          return true;
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }

    changeLoadingStatus();
    return false;
  }

  Future<bool> editCaff(int caffId, PlatformFile? caffFile, String title) async {
    changeLoadingStatus();

    MultipartFile? caffMultipartFile;

    if (caffFile != null) {
      caffMultipartFile =
          MultipartFile.fromBytes(caffFile.bytes!, filename: caffFile.name);
    }

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult =
      await _caffService.editCaff(token, caffId, caffMultipartFile, title);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          Globals.showMessage('Caff file uploaded successfully');
          return true;
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }

    changeLoadingStatus();
    return false;
  }

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
      ApiResult? apiResult =
          await _caffService.addComment(token, caffId, content);

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
      ApiResult? apiResult =
          await _caffService.editComment(token, caffId, content);

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
