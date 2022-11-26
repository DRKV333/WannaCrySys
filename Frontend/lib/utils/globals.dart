import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Globals {
  static final Globals _instance = Globals();

  factory Globals() {
    return _instance;
  }

  static void showMessage(String message, [bool isError = false]) =>
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: isError ? Colors.red : Colors.green);
}
