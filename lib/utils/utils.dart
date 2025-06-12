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
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user can't tap outside to close
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Please wait..."),
            ],
          ),
        );
      },
    );
  }
}