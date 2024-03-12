import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/constants/colors/app_colors.dart';
import 'package:flutter_assessment/feature/data/model/login/login_response_model.dart';
import 'package:flutter_assessment/feature/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:textfield_tags/textfield_tags.dart';
import '../../../../core/constants/strings/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../data/model/dependencies/dependencies_response_model.dart';
import '../../bloc/login/login_state.dart';
import '../../bloc/register/register_bloc.dart';
import '../../widget/input_widget.dart';
import '../../widget/sub_txt_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late LoginBloc _loginBloc;
  late final RegisterBloc _registerBloc;
  String _avatarUrl = "";
  int _userTypeIndex = 5;
  UserType? _userType;
  int? _userGender;
  late List<Tag> _skillsList;
  late List<UserTag> _userTags;
  final List<Tag> _userSkills = [];
  late List<SocialMedia> _socialMediaList;
  late List<String> _userSocialMedia;
  final List _socialMediaValues = [];

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    if (_loginBloc.state.loginResponse != null &&
        _registerBloc.state.dependencies != null) {
      _avatarUrl = _loginBloc.state.loginResponse!.data?.avatar ?? "";
      _userTypeIndex = _loginBloc.state.loginResponse!.data?.type?.code ?? 5;
      int typesListLength =
          _registerBloc.state.dependencies!.data?.types!.length ?? 0;
      if ((_userTypeIndex - 1) < typesListLength) {
        _userType =
            _registerBloc.state.dependencies!.data?.types?[_userTypeIndex - 1];
      }
      if (_loginBloc.state.loginResponse!.data?.gender != null) {
        _userGender = _loginBloc.state.loginResponse!.data?.gender;
      }
      _skillsList = _registerBloc.state.dependencies!.data?.tags ?? [];
      _userTags = _loginBloc.state.loginResponse!.data?.tags ?? [];
      if (_skillsList.isNotEmpty && _userTags.isNotEmpty) {
        for (UserTag tag in _userTags) {
          _userSkills.add(
              _skillsList.firstWhere((element) => (element.value == tag.id)));
        }
      }
      _socialMediaList =
          _registerBloc.state.dependencies!.data?.socialMedia ?? [];
      _userSocialMedia =
          _loginBloc.state.loginResponse!.data?.favoriteSocialMedia ?? [];
      if (_socialMediaList.isNotEmpty && _userSocialMedia.isNotEmpty) {
        for (int x = 0; x < _socialMediaList.length; x++) {
          if (_userSocialMedia.contains(_socialMediaList[x].value)) {
            _socialMediaValues.add({
              "label": _socialMediaList[x].label ?? "",
              "value": true,
              "icon": "assets/icon/${_socialMediaList[x].value}_ic.svg"
            });
          } else {
            _socialMediaValues.add({
              "label": _socialMediaList[x].label ?? "",
              "value": false,
              "icon": "assets/icon/${_socialMediaList[x].value}_ic.svg"
            });
          }
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return _getScreenBody();
      },
    );
  }

  Widget _getScreenBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getHeader(),
          _getUserAvatar(),
          SizedBox(
            height: 30.h,
          ),
          _getUserInfo(),
          _getUserType(),
          _getAbout(),
          _getSalary(),
          _getBirthDate(),
          _getGender(),
          _getTags(),
          _getSocialMedia(),
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
                    backgroundImage: _avatarUrl.isEmpty
                        ? Image.asset("assets/icon/avatar_placeholder_ic.jpg")
                            .image
                        : NetworkImage(_avatarUrl),
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
                initialVal:
                    _loginBloc.state.loginResponse?.data?.firstName ?? "",
                margin: EdgeInsets.only(
                    top: 10.h, left: 20.w, bottom: 10.h, right: 5.w),
              ),
            ),
            Expanded(
              child: InputWidget(
                title: AppStrings.lastName,
                isReadOnly: true,
                initialVal:
                    _loginBloc.state.loginResponse?.data?.lastName ?? "",
                margin: EdgeInsets.only(
                    top: 10.h, left: 5.w, bottom: 10.h, right: 20.w),
              ),
            ),
          ],
        ),
        InputWidget(
          title: AppStrings.emailAddress,
          isReadOnly: true,
          initialVal: _loginBloc.state.loginResponse?.data?.email ?? "",
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
        ),
        InputWidget(
          title: AppStrings.password,
          obscureText: true,
          maxLines: 1,
          isReadOnly: true,
          initialVal: "",
          suffixIcon: SvgPicture.asset('assets/icon/password_ic.svg',
              width: 18.w, height: 18.h, fit: BoxFit.scaleDown),
        ),
      ],
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
                onChanged: (UserType? value) {},
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
      initialVal: _loginBloc.state.loginResponse?.data?.about ?? "",
      isReadOnly: true,
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
    );
  }

  Widget _getSalary() {
    return InputWidget(
      title: AppStrings.emailAddress,
      isReadOnly: true,
      initialVal: "SAR ${_loginBloc.state.loginResponse?.data?.salary ?? 0}",
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
    );
  }

  Widget _getBirthDate() {
    return InputWidget(
      title: AppStrings.birthDate,
      isReadOnly: true,
      initialVal: _loginBloc.state.loginResponse?.data?.birthDate ?? "",
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
                    groupValue: _userGender,
                    hoverColor: AppColors.color_C3C5C8,
                    activeColor: AppColors.appMainColor,
                    contentPadding: const EdgeInsets.all(0),
                    toggleable: false,
                    onChanged: (int? value) {},
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                    title: const Text(AppStrings.female),
                    value: 1,
                    groupValue: _userGender,
                    activeColor: AppColors.appMainColor,
                    toggleable: false,
                    contentPadding: const EdgeInsets.all(0),
                    onChanged: (int? value) {},
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Widget _getTags() {
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
            child: TextFieldTags<Tag>(
              textSeparators: const [","],
              textfieldTagsController: TextfieldTagsController<Tag>(),
              initialTags: _userSkills,
              letterCase: LetterCase.normal,
              inputFieldBuilder: (context, inputFieldValues) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.transparent,
                      prefixIconConstraints: BoxConstraints(
                          maxWidth: ScreenUtil().screenWidth * 0.74),
                      prefixIcon: _userSkills.isNotEmpty
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: _userSkills.map((Tag tag) {
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
                                        tag.label ?? "",
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SubTxtWidget(AppStrings.favSocialMedia),
        SizedBox(
          height: 10.h,
        ),
        Column(
          children: List.generate(
              _socialMediaValues.length,
              (index) => Row(
                    children: [
                      Checkbox(
                        value: _socialMediaValues[index]["value"],
                        checkColor: Colors.white,
                        activeColor: AppColors.appMainColor,
                        side: MaterialStateBorderSide.resolveWith(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return const BorderSide(
                                width: 1,
                                color: AppColors.appMainColor,
                              );
                            }
                            return const BorderSide(
                              width: 1,
                              color: AppColors.color_C3C5C8,
                            );
                          },
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (bool? value) {},
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      SvgPicture.asset(_socialMediaValues[index]["icon"],
                          width: 20.w, height: 20.h),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        _socialMediaValues[index]["label"],
                        style: AppTxtStyles.btnTxtStyle
                            .copyWith(color: Colors.black),
                      )
                    ],
                  )),
        )
      ]),
    );
  }
}
