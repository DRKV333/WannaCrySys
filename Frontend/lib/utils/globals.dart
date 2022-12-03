import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Globals {
  static final Globals _instance = Globals();
  static const String baseIp = 'https://192.168.1.99:8081';

  factory Globals() {
    return _instance;
  }

  static RegExp containsLowerCase = RegExp(r'(?=.*[a-z])');
  static RegExp containsUpperCase = RegExp(r'(?=.*[A-Z])');
  static RegExp containsNumber = RegExp(r'(?=.*\d)');
  static RegExp containsNonAlphanumeric = RegExp(r'(?=.*[-+_!@#$%^&*.,?])');

  static void showMessage(String message, [bool isError = false]) =>
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: isError ? Colors.red : Colors.green);

  static RegExp lengthRegExp(int min, int max) =>
      RegExp(r'^(?=.{' "$min,$max" r'}$).*');

  static String? validateName(String? value,
      {bool required = true, bool validateRegExp = true}) {
    if (required && (value == null || value.isEmpty)) {
      return 'Name must be filled';
    }
    if (validateRegExp) {
      if (value != null && value.isNotEmpty) {
        value = value.trim();
        int min = 8, max = 32;

        if (!lengthRegExp(min, max).hasMatch(value)) {
          return "Name's length must be between $min and $max";
        }
        if (containsNumber.hasMatch(value) ||
            containsNonAlphanumeric.hasMatch(value)) {
          return 'Name must contain only letters';
        }
      }
    }
    return null;
  }

  static String? validateUsername(String? value, {bool validateRegExp = true}) {
    if (value == null || value.isEmpty) {
      return 'Name must be filled';
    }

    if (validateRegExp) {
      value = value.trim().toLowerCase();

      int min = 8, max = 64;
      if (!lengthRegExp(min, max).hasMatch(value)) {
        return "Username's length must be between $min and $max";
      }

      if (containsNonAlphanumeric.hasMatch(value)) {
        return 'Username must contain only alphanumeric characters';
      }
    }

    return null;
  }

  static String? validatePassword(String? value,
      {bool required = true, bool validateRegExp = true}) {
    if (required && (value == null || value.isEmpty)) {
      return 'Password must be filled';
    }
    if (validateRegExp) {
      if (value != null && value.isNotEmpty) {
        value = value.trim();
        int min = 8, max = 64;

        if (!lengthRegExp(min, max).hasMatch(value)) {
          return "Password's length must be between $min and $max";
        }
        if (!containsLowerCase.hasMatch(value)) {
          return 'Password must contain at least one lowercase letter';
        }
        if (!containsUpperCase.hasMatch(value)) {
          return 'Password must contain at least one uppercase letter';
        }
        if (!containsNumber.hasMatch(value)) {
          return 'Password must contain at least one number';
        }
        if (!containsNonAlphanumeric.hasMatch(value)) {
          return 'Password must contain at least one non-alphanumeric character';
        }
      }
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? matchWith,
      {bool required = true}) {
    if (required && (value == null || value.isEmpty)) {
      return 'Confirm password must be filled';
    }
    if (value != matchWith) return 'Passwords do not match';
    return null;
  }

  static String? validateTitle(String? value,
      {bool required = true, bool validateRegExp = true}) {
    if (required && (value == null || value.isEmpty)) {
      return 'Title must be filled';
    }
    if (validateRegExp) {
      if (value != null && value.isNotEmpty) {
        value = value.trim();
        int min = 8, max = 128;

        if (!lengthRegExp(min, max).hasMatch(value)) {
          return "Title's length must be between $min and $max";
        }
        if (containsNonAlphanumeric.hasMatch(value)) {
          return 'Title must contain only alphanumeric characters';
        }
      }
    }
    return null;
  }
}
