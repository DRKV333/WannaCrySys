import 'package:caff_parser/providers/provider_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caff_parser/models/api_result.dart';
import 'package:caff_parser/network/caff_service.dart';
import 'package:caff_parser/utils/globals.dart';
import 'package:file_picker/file_picker.dart';
import '../models/caff_details_dto.dart';
import '../models/comment_dto.dart';

class CaffProvider extends ProviderBase {
  final CaffService _caffService;
  CaffDetailsDto caff = CaffDetailsDto(id: 0, title: "", comments: [], isPurchased: false);
  List<CommentDto> commentList = <CommentDto>[];
  final TextEditingController commentController = TextEditingController();
  int caffId = 0;

  CaffProvider(this._caffService, SharedPreferences sharedPreferences) : super(sharedPreferences);

  Future<bool> createCaff(PlatformFile caffFile, String title) async {
    changeLoadingStatus();

    MultipartFile caffMultipartFile =
        MultipartFile.fromBytes(caffFile.bytes!, filename: caffFile.name);

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult =
          await _caffService.createCaff(token, caffMultipartFile, title);

      changeLoadingStatus();
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
      changeLoadingStatus();
      if (apiResult != null) {
        if (apiResult.isSuccess) {
          Globals.showMessage('Caff file updated successfully');
          return true;
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }
    return false;
  }

  Future<void> getCaff() async {

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _caffService.getCaff(token, caffId);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          caff = CaffDetailsDto.fromJson(apiResult.data as Map<String, dynamic>);
          commentList.clear();
          for(var c in caff.comments){
            commentList.add(CommentDto.fromJson(c as Map<String, dynamic>));
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

  Future<void> purchaseCaff() async {

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _caffService.purchaseCaff(token, caffId);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          getCaff();
          notifyListeners();
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }
  }

  Future<void> downloadCaff() async {

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _caffService.downloadCaff(token, caffId, caff.title!);
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

  Future<bool> deleteCaff() async {

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _caffService.deleteCaff(token, caffId);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          return true;
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }
    return false;
  }

  Future<void> addComment(int caffId, String content) async {
    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult =
          await _caffService.addComment(token, caffId, content);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          getCaff();
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }
  }

  Future<void> editComment(int commentId, String content) async {

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _caffService.editComment(token, commentId, content);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          getCaff();
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }
  }

  Future<void> deleteComment(int commentId) async {

    String? token = await isLoggedIn();
    if (token != null) {
      ApiResult? apiResult = await _caffService.deleteComment(token, commentId);

      if (apiResult != null) {
        if (apiResult.isSuccess) {
          getCaff();
        } else {
          Globals.showMessage(apiResult.errorMessage!, true);
        }
      } else {
        Globals.showMessage('Something went wrong', true);
      }
    }
  }

  bool canModify(){
    String? token = getToken();
    if (token != null) {
      Map<String, dynamic> tokenPayload = JwtToken.payload(token);
      if(tokenPayload["role"] == "Administrator"){
        return true;
      }
    }
    return false;
  }
}
