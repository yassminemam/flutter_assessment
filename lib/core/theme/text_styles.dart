import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/constants/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTxtStyles{
  static final mainFontStyle = TextStyle(
      fontSize: 18.sp,
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontFamily: "montserrat_regular"
  );
  static final subHeaderFontStyle = TextStyle(
      fontSize: 12.sp,
      color: AppColors.color_696F79,
      fontWeight: FontWeight.w500,
      fontFamily: "montserrat_regular"
  );

  static final inputTxtFontStyle = TextStyle(
      fontSize: 16.sp,
      color: AppColors.color_333333,
      fontWeight: FontWeight.w500,
      fontFamily: "montserrat_regular"
  );
  static final btnTxtStyle = TextStyle(
      fontSize: 14.sp,
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontFamily: "montserrat_regular"
  );
  static final stepTxtStyle = TextStyle(
      fontSize: 12.sp,
      color: AppColors.appMainColor,
      fontWeight: FontWeight.w600,
      fontFamily: "montserrat_regular"
  );
}