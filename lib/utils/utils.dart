import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Utils {
  static void showErrorToast(String msg, BuildContext context) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.white,
      fontSize: 20,
      backgroundColor: Colors.red,
    );
  }
  static void showSuccessToast(String msg, BuildContext context) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.white,
      fontSize: 20,
      backgroundColor: Colors.green,
    );
  }
}