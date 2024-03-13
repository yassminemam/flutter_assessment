import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/constants/strings/app_assets.dart';
import 'package:flutter_assessment/core/theme/text_styles.dart';
import 'package:flutter_assessment/feature/presentation/widget/sub_txt_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/colors/app_colors.dart';

class ScaleWidget extends StatelessWidget {
  var onAdd;
  var onSubtract;
  Color? bgColor;
  String title;
  double? radius;
  var margin;
  int? value;

  ScaleWidget(
      {required this.title,
      this.bgColor,
      this.value,
      this.onAdd,
      this.onSubtract,
      this.radius,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      alignment: AlignmentDirectional.topStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...{
            SubTxtWidget(title),
            SizedBox(
              height: 10.h,
            ),
          },
          Container(
              decoration: BoxDecoration(
                  color: bgColor ?? AppColors.color_F9F9F9,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.r),
                  )),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: onSubtract,
                    child: SvgPicture.asset(AppAssets.subtract_ic,
                        width: 30.w, height: 30.h),
                  )),
                  Expanded(
                      child: Text(
                    "SAR $value",
                    style: AppTxtStyles.inputTxtStyle,
                  )),
                  Expanded(
                      child: InkWell(
                    onTap: onAdd,
                    child: SvgPicture.asset(AppAssets.add_ic,
                        width: 30.w, height: 30.h),
                  ))
                ],
              ))
        ],
      ),
    );
  }
}
