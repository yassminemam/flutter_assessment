import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/constants/colors/app_colors.dart';
import 'package:flutter_assessment/feature/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_assessment/feature/presentation/bloc/register/register_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/constants/strings/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/util/lock_overlay.dart';
import '../../../../core/util/tools.dart';
import '../../../data/model/dependencies/dependencies_response_model.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/login/login_state.dart';
import '../../widget/input_widget.dart';
import '../../widget/sub_txt_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late RegisterBloc _registerBloc;
  late HomeBloc _homeBloc;
  String _avatarFilePath = "";
  int _userTypeIndex = 0;
  UserType? _userType;
  int? _userGender;

  @override
  void initState() {
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SafeArea(child: _getScreenBody());
        },
      ),
    );
  }

  Widget _getScreenBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getHeader(),
          _getUserAvatar(),
          SizedBox(height: 30.h,),
          _getUserInfo(),
          _getUserType(),
          _getAbout(),
          _getSalary(),
          _getBirthDate(),
          _getGender(),
          /*_getTags(),
          _getSocialMedia(),*/
          SizedBox(
            height: 40.h,
          )
        ],
      ),
    );
  }

  Widget _getHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
      child: Text(
        AppStrings.profileHeader,
        style: AppTxtStyles.mainFontStyle,
      ),
    );
  }

  Widget _getUserAvatar() {
    return Center(
      child: SizedBox(
        width: 83,
        height: 85,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                      Border.all(color: AppColors.appMainColor, width: 1)),
                  child: CircleAvatar(
                    radius: 41.5.r,
                    backgroundImage: _avatarFilePath.isEmpty
                        ? Image
                        .asset("assets/icon/avatar_placeholder_ic.jpg")
                        .image
                        : FileImage(File(_avatarFilePath)),
                  ),
                )),
            Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset('assets/icon/add_img_ic.svg',
                  width: 25.w, height: 25.h),
            )
          ],
        ),
      ),
    );
  }

  Widget _getUserInfo() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InputWidget(
                title: AppStrings.firstName,
                isReadOnly: true,
                initialVal: "Yasmeen",
                margin: EdgeInsets.only(
                    top: 10.h, left: 20.w, bottom: 10.h, right: 5.w),
              ),
            ),
            Expanded(
              child: InputWidget(
                title: AppStrings.lastName,
                isReadOnly: true,
                initialVal: "Yasmeen",
                margin: EdgeInsets.only(
                    top: 10.h, left: 5.w, bottom: 10.h, right: 20.w),
              ),
            ),
          ],
        ),
        InputWidget(
          title: AppStrings.emailAddress,
          isReadOnly: true,
          initialVal: "Yasmeen",
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
        ),
        InputWidget(
          title: AppStrings.password,
          obscureText: true,
          maxLines: 1,
          isReadOnly: true,
          initialVal: "Yasmeen",
          suffixIcon: SvgPicture.asset('assets/icon/password_ic.svg',
              width: 18.w, height: 18.h, fit: BoxFit.scaleDown),
        ),
      ]
      ,
    );
  }

  Widget _getUserType() {
    List<UserType> userTypes =
        _registerBloc.state.dependencies?.data?.types ?? [];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          for (UserType type in userTypes) ...{
            Expanded(
              child: RadioListTile<UserType>(
                title: Text("${type.label?.toUpperCase()}"),
                value: type,
                groupValue: _userType,
                activeColor: AppColors.appMainColor,
                contentPadding: const EdgeInsets.all(0),
                onChanged: (UserType? value) {
                  if (value != null) {
                    setState(() {
                      _userTypeIndex = value.value ?? 0;
                      _userType = value;
                    });
                  }
                },
              ),
            )
          }
        ],
      ),
    );
  }

  Widget _getAbout() {
    return InputWidget(
      title: AppStrings.about,
      height: 113.h,
      initialVal: "Yasmeen",
      isReadOnly: true,
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
    );
  }

  Widget _getSalary() {
    return InputWidget(
      title: AppStrings.emailAddress,
      isReadOnly: true,
      initialVal: "SAR 100",
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
    );
  }

  Widget _getBirthDate() {
    return InputWidget(
      title: AppStrings.birthDate,
      isReadOnly: true,
      initialVal: "1970-01-25",
      suffixIcon: SvgPicture.asset('assets/icon/calendar_ic.svg',
          width: 18.w, height: 18.h, fit: BoxFit.scaleDown),
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
    );
  }

  Widget _getGender() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubTxtWidget(AppStrings.gender),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<int>(
                    title: const Text(AppStrings.male),
                    value: 0,
                    groupValue: 1,
                    activeColor: AppColors.appMainColor,
                    contentPadding: const EdgeInsets.all(0),
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          _userGender = value;
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                    title: const Text(AppStrings.female),
                    value: 1,
                    groupValue: 1,
                    activeColor: AppColors.appMainColor,
                    contentPadding: const EdgeInsets.all(0),
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          _userGender = value;
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          ],
        ));
  }

/*Widget _getTags() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubTxtWidget(AppStrings.skills),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 94.h,
            decoration: BoxDecoration(
                color: AppColors.color_F9F9F9,
                borderRadius: BorderRadius.all(
                  Radius.circular(16.r),
                )),
            child: TextFieldTags<ProfileTag>(
              textSeparators: const [","],
              initialTags: _profileTags,
              letterCase: LetterCase.normal,
              inputFieldBuilder: (context, inputFieldValues) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  child: TextField(
                    controller: inputFieldValues.textEditingController,
                    focusNode: inputFieldValues.focusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.transparent,
                      errorText: inputFieldValues.error,
                      prefixIconConstraints: BoxConstraints(
                          maxWidth: ScreenUtil().screenWidth * 0.74),
                      prefixIcon: inputFieldValues.tags.isNotEmpty
                          ? SingleChildScrollView(
                              controller: inputFieldValues.tagScrollController,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: inputFieldValues.tags
                                      .map((ProfileTag tag) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0.r),
                                    ),
                                    color: AppColors.color_E9F9F1,
                                  ),
                                  margin:
                                      EdgeInsets.only(right: 11.w, top: 11.h),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0.w, vertical: 4.0.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        tag,
                                        style: AppTxtStyles.subHeaderFontStyle
                                            .copyWith(
                                                color: AppColors.appMainColor),
                                      ),
                                      SizedBox(width: 5.0.w),
                                      SvgPicture.asset(
                                          'assets/icon/delete_tag_ic.svg',
                                          width: 12.w,
                                          height: 12.h),
                                    ],
                                  ),
                                );
                              }).toList()),
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSocialMedia() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      child: Column(children: [
        SubTxtWidget(AppStrings.skills),
        SizedBox(
          height: 10.h,
        ),
        Column(
          children: List.generate(
            _socialMediaValues.length,
            (index) => CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Row(
                children: [
                  SvgPicture.asset(_socialMediaValues[index]["icon"],
                      width: 20.w, height: 20.h),
                  SizedBox(
                    width: 3.w,
                  ),
                  Text(
                    _socialMediaValues[index]["label"],
                    style:
                        AppTxtStyles.btnTxtStyle.copyWith(color: Colors.black),
                  )
                ],
              ),
              value: _socialMediaValues[index]["value"],
              onChanged: null,
            ),
          ),
        )
      ]),
    );
  }*/
}
