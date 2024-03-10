import 'package:flutter/material.dart';
class Tools {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static void showErrorMessage(message) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
