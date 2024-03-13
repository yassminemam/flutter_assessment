import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/constants/colors/app_colors.dart';
import 'package:flutter_assessment/core/constants/strings/app_assets.dart';
import 'package:flutter_assessment/core/theme/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepProgressView extends StatelessWidget {
  final int _steps;
  final int _curStep;
  final List<String> titles;
  Function(int selectedTab)? onSelectTab;

  StepProgressView(
      {super.key,
      required int curStep,
      required int steps,
      required this.titles,
      this.onSelectTab})
      : _steps = steps,
        _curStep = curStep;

  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: 60.h,
      margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: Row(
        children: _iconViews(),
      ),
    );
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    int count = 1;
    double singleTabWidth = (ScreenUtil().screenWidth - 40.w) / _steps;
    while (count <= _steps) {
      if (count == _curStep) {
        //adding current step
        list.add(Container(
            padding: const EdgeInsets.all(0),
            alignment: AlignmentDirectional.center,
            width: singleTabWidth,
            height: 60.h,
            child: Column(
              children: [
                Text(
                  titles[count - 1],
                  style: AppTxtStyles.stepTxtStyle,
                ),
                SizedBox(
                  height: 13.h,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                      color: AppColors.appMainColor,
                      thickness: 2.h,
                    )),
                    Container(
                      width: 25.w,
                      height: 25.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: AppColors.appMainColor, width: 2.w),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.5.r),
                          )),
                      child: Center(
                        child: Text(
                          count.toString(),
                          style: AppTxtStyles.stepTxtStyle,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      color: AppColors.color_E6EAEF,
                      thickness: 2.h,
                    ))
                  ],
                )
              ],
            )));
      } else if (count < _steps) {
        //adding done step
        list.add(Container(
            padding: const EdgeInsets.all(0),
            alignment: AlignmentDirectional.center,
            width: singleTabWidth,
            height: 60.h,
            child: Column(
              children: [
                Text(
                  titles[count - 1],
                  style: AppTxtStyles.stepTxtStyle,
                ),
                SizedBox(
                  height: 13.h,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                      color: AppColors.appMainColor,
                      thickness: 2.h,
                    )),
                    SvgPicture.asset(AppAssets.done_ic,
                        width: 25.w, height: 25.h, fit: BoxFit.scaleDown),
                    Expanded(
                        child: Divider(
                      color: AppColors.appMainColor,
                      thickness: 2.h,
                    ))
                  ],
                )
              ],
            )));
      } else {
        //adding upcoming step
        list.add(Container(
            padding: const EdgeInsets.all(0),
            alignment: AlignmentDirectional.center,
            width: singleTabWidth,
            height: 60.h,
            child: Column(
              children: [
                Text(
                  titles[count - 1],
                  style: AppTxtStyles.stepTxtStyle.copyWith(
                      color: AppColors.color_C3C5C8,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 13.h,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                      color: AppColors.color_E6EAEF,
                      thickness: 2.h,
                    )),
                    SvgPicture.asset(AppAssets.gray_circle_ic,
                        width: 25.w, height: 25.h, fit: BoxFit.scaleDown),
                    Expanded(
                        child: Divider(
                      color: AppColors.color_E6EAEF,
                      thickness: 2.h,
                    ))
                  ],
                )
              ],
            )));
      }
      count++;
    }

    return list;
  }
}
