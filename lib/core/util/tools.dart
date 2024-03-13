import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/constants/colors/app_colors.dart';

class Tools {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void showErrorMessage(message) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  static void showHintMsg(message) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      backgroundColor: AppColors.appMainColor,
    ));
  }
}
