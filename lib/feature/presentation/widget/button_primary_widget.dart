import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/constants/colors/app_colors.dart';
import 'package:flutter_assessment/core/theme/text_styles.dart';
import 'package:flutter_assessment/feature/presentation/widget/sub_txt_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef callback = Function();

class ButtonPrimaryWidget extends StatelessWidget {
  String title;
  callback? onTap;
  Widget? leading;
  Widget? trailing;
  Color? color;
  Color? txtColor;
  double? paddingVertical;
  double? paddingHorizontal;
  double? marginVertical;
  double? marginHorizontal;
  double? radius;
  double? width;
  double? height;
  Color? borderColor;

  ButtonPrimaryWidget(this.title,
      {this.onTap,
      this.leading,
      this.trailing,
      this.color,
      this.txtColor,
      this.paddingVertical,
      this.paddingHorizontal,
      this.marginVertical,
      this.marginHorizontal,
      this.radius,
      this.width,
      this.borderColor,
      this.height});

  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    color = color ?? AppColors.appMainColor;
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: width?.w ?? wid.w,
        height: height?.h ?? 65.h,
        padding: EdgeInsets.symmetric(vertical: paddingVertical?.h ?? 20.h),
        margin: EdgeInsets.symmetric(
            vertical: marginVertical?.h ?? 30.h, horizontal: marginHorizontal?.w ?? 20.w),
        decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: borderColor ?? color ?? AppColors.appMainColor,
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(radius?.r ?? 12.r))),
        child: Center(
          child: Text(title, style: AppTxtStyles.btnTxtStyle,),
        )
      ),
    );
  }
}
