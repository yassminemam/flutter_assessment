import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_assessment/core/constants/colors/app_colors.dart';
import 'package:flutter_assessment/core/constants/strings/app_strings.dart';
import 'package:flutter_assessment/core/theme/text_styles.dart';
import 'package:flutter_assessment/feature/presentation/widget/sub_txt_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';

enum ValidationType { EMAIL, TEXT }

class InputWidget extends StatelessWidget {
  TextEditingController controller;
  var inputType;
  var onChanged;
  var onDone;
  var onTap;
  Color? bgColor;
  String title;
  String? hint;
  int? maxLines;
  int? minLines;
  ValidationType validator;
  double? radius;
  List<TextInputFormatter>? inputFormatters;
  Widget? suffixIcon;
  Widget? prefixIcon;
  EdgeInsets? contentPadding;
  String? errorMsg;
  bool obscureText;
  var margin;
  bool? isReadOnly;
  double? height;

  InputWidget(
      {required this.controller,
      this.inputType = TextInputType.text,
      required this.title,
      this.bgColor,
      this.hint,
      this.height,
      this.maxLines,
      this.minLines,
      this.validator = ValidationType.TEXT,
      this.onChanged,
      this.onDone,
      this.onTap,
      this.inputFormatters,
      this.suffixIcon,
      this.radius,
      this.contentPadding,
      this.errorMsg,
      this.prefixIcon,
      this.margin,
      this.isReadOnly,
      this.obscureText = false});

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
          Form(
              autovalidateMode: AutovalidateMode.always,
              child: Container(
                decoration: BoxDecoration(
                    color: bgColor ?? AppColors.color_F9F9F9,
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.r),
                    )),
                height: height ?? 56.h,
                child: TextFormField(
                  controller: controller,
                  keyboardType: inputType,
                  textAlign: TextAlign.start,
                  inputFormatters: inputFormatters ??
                      [FilteringTextInputFormatter.singleLineFormatter],
                  maxLines: maxLines,
                  minLines: minLines ?? 1,
                  onChanged: onChanged,
                  obscureText: obscureText,
                  onFieldSubmitted: onDone,
                  onTap: onTap,
                  readOnly: isReadOnly ?? false,
                  cursorColor: AppColors.appMainColor,
                  style: AppTxtStyles.inputTxtFontStyle,
                  decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    contentPadding: contentPadding ??
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    hintText: hint ?? "",
                    hintStyle: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.color_696F79),
                    counterText: "",
                    suffixIcon: suffixIcon,
                    prefixIcon: prefixIcon,
                  ),
                  validator: MultiValidator([
                    if (validator == ValidationType.EMAIL)
                      EmailValidator(errorText: AppStrings.errorEnterValidEmail),
                  ]),
                ),
              )
          )
        ],
      ),
    );
  }
}
