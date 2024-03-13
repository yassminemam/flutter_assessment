import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_assessment/core/constants/strings/app_assets.dart';
import 'package:flutter_assessment/core/theme/text_styles.dart';
import 'package:flutter_assessment/feature/presentation/widget/scale_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:textfield_tags/textfield_tags.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/constants/strings/app_strings.dart';
import '../../../data/model/dependencies/dependencies_response_model.dart';
import '../../../data/model/register/register_request_model.dart';
import '../../bloc/register/register_bloc.dart';
import '../../bloc/register/register_event.dart';
import '../../widget/button_primary_widget.dart';
import '../../widget/input_widget.dart';
import '../../widget/sub_txt_widget.dart';
import 'package:dio/dio.dart' as dio;

class RegisterSecondStepPage extends StatefulWidget {
  const RegisterSecondStepPage({super.key});

  @override
  State<RegisterSecondStepPage> createState() => _RegisterSecondStepPageState();
}

class _RegisterSecondStepPageState extends State<RegisterSecondStepPage> {
  late final RegisterBloc _registerBloc;
  final TextEditingController _aboutCon = TextEditingController();
  final TextEditingController _birthDateCon = TextEditingController();
  final TextfieldTagsController<String> _textFieldTagsController =
      TextfieldTagsController<String>();
  int? _userGender;
  int _salary = 100;
  late List<Tag> _skillsList;
  final List<String> _skillsLabels = [];
  final List<String> _selectedSkills = [];
  final List<num> _selectedSkillsIds = [];
  late List<SocialMedia> _socialMediaList;
  final List _socialMediaValues = [];
  final List _selectedSocialMedia = [];
  String _avatarFilePath = "";
  String _avatarFileName = "";

  @override
  void initState() {
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _skillsList = _registerBloc.state.dependencies?.data?.tags ?? [];
    for (Tag t in _skillsList) {
      _skillsLabels.add(t.label ?? "");
    }
    _socialMediaList =
        _registerBloc.state.dependencies?.data?.socialMedia ?? [];
    for (SocialMedia s in _socialMediaList) {
      _socialMediaValues.add({
        "label": s.label ?? "",
        "value": false,
        "icon": AppAssets.getSocialMediaAssets(value: s.value ?? "")
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getScreenBody();
  }

  Widget _getScreenBody() {
    return SingleChildScrollView(
        child: Column(
      children: [
        _getUserAvatar(),
        _getAbout(),
        _getSalary(),
        _getBirthDate(),
        _getGender(),
        _getTags(),
        _getSocialMedia(),
        _getSubmitBtn(),
        SizedBox(
          height: 50.h,
        )
      ],
    ));
  }

  Widget _getUserAvatar() {
    return InkWell(
        onTap: _requestStoragePermission,
        child: SizedBox(
          width: 83,
          height: 85,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.appMainColor, width: 1)),
                    child: CircleAvatar(
                      radius: 41.5.r,
                      backgroundImage: _avatarFilePath.isEmpty
                          ? Image.asset(AppAssets.avatar_placeholder_ic)
                              .image
                          : FileImage(File(_avatarFilePath)),
                    ),
                  )),
              Positioned(
                bottom: 0,
                right: 0,
                child: SvgPicture.asset(AppAssets.add_img_ic,
                    width: 25.w, height: 25.h),
              )
            ],
          ),
        ));
  }

  _requestStoragePermission() async {
    int? sdkInt = 32;
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      sdkInt = androidInfo.version.sdkInt;
    }
    Permission storagePrem =
        (Platform.isIOS) ? Permission.storage : Permission.photos;
    bool storagePremStatus = await storagePrem.isGranted;
    if (storagePremStatus || sdkInt >= 33) {
      _pickImageFromGallery();
    } else {
      await storagePrem.request().then((newStatus) {
        if (newStatus == PermissionStatus.denied) {
          openAppSettings().then((value) {
            if (value) {
              _pickImageFromGallery();
            }
          });
        } else if (newStatus == PermissionStatus.granted) {
          _pickImageFromGallery();
        }
      });
    }
  }

  _pickImageFromGallery() {
    final ImagePicker picker = ImagePicker();
    picker.pickImage(source: ImageSource.gallery).then((file) {
      if (file != null) {
        setState(() {
          _avatarFilePath = file.path;
          _avatarFileName = file.name;
        });
      }
    });
  }

  Widget _getAbout() {
    return InputWidget(
      title: AppStrings.about,
      controller: _aboutCon,
      height: 113.h,
      maxLines: null,
      inputFormatters: [
        LengthLimitingTextInputFormatter(1000),
      ],
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
    );
  }

  Widget _getSalary() {
    return ScaleWidget(
      title: AppStrings.salary,
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      value: _salary,
      onAdd: () {
        setState(() {
          _salary += 100;
        });
      },
      onSubtract: () {
        if (_salary > 100) {
          setState(() {
            _salary -= 100;
          });
        }
      },
    );
  }

  Widget _getBirthDate() {
    return InputWidget(
      title: AppStrings.birthDate,
      controller: _birthDateCon,
      isReadOnly: true,
      maxLines: 1,
      suffixIcon: SvgPicture.asset(AppAssets.calendar_ic,
          width: 18.w, height: 18.h, fit: BoxFit.scaleDown),
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now().subtract(const Duration(days: 1)),
          firstDate: DateTime(1950),
          lastDate: DateTime.now().subtract(const Duration(days: 1)),
        );
        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            _birthDateCon.text = formattedDate;
          });
        }
      },
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
                    groupValue: _userGender,
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
            child: Autocomplete<Tag>(
              optionsViewOpenDirection: OptionsViewOpenDirection.up,
              optionsViewBuilder: (context, onSelected, options) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      elevation: 4.0,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 50.h),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Tag option = options.elementAt(index);
                            return TextButton(
                              onPressed: () {
                                onSelected(option);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Text(
                                    option.label ?? "",
                                    textAlign: TextAlign.left,
                                    style: AppTxtStyles.subHeaderTxtStyle
                                        .copyWith(
                                      color: AppColors.appMainColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<Tag>.empty();
                }
                return _skillsList.where((Tag option) {
                  return option.label!
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (Tag selectedTag) {
                _selectedSkillsIds.add(selectedTag.value ?? -1);
                _textFieldTagsController.onSubmitted(selectedTag.label ?? "");
              },
              fieldViewBuilder: (context, textEditingController, focusNode,
                  onFieldSubmitted) {
                return TextFieldTags<String>(
                  textEditingController: textEditingController,
                  focusNode: focusNode,
                  textfieldTagsController: _textFieldTagsController,
                  textSeparators: const [","],
                  initialTags: _selectedSkills,
                  letterCase: LetterCase.normal,
                  validator: (String tag) {
                    if (!_skillsLabels.contains(tag)) {
                      return AppStrings.errorSelectFromList;
                    } else if (_textFieldTagsController.getTags!
                        .contains(tag)) {
                      return AppStrings.errorSelectedBefore;
                    }
                    return null;
                  },
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
                                  controller:
                                      inputFieldValues.tagScrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: inputFieldValues.tags
                                          .map((String tag) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0.r),
                                        ),
                                        color: AppColors.color_E9F9F1,
                                      ),
                                      margin: EdgeInsets.only(
                                          right: 11.w, top: 11.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0.w, vertical: 4.0.h),
                                      child: InkWell(
                                        onTap: () {
                                          inputFieldValues.onTagDelete(tag);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              tag,
                                              style: AppTxtStyles
                                                  .subHeaderTxtStyle
                                                  .copyWith(
                                                      color: AppColors
                                                          .appMainColor),
                                            ),
                                            SizedBox(width: 5.0.w),
                                            SvgPicture.asset(
                                                AppAssets.delete_tag_ic,
                                                width: 12.w,
                                                height: 12.h),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList()),
                                )
                              : null,
                        ),
                        onChanged: inputFieldValues.onChanged,
                        onSubmitted: inputFieldValues.onSubmitted,
                      ),
                    );
                  },
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
                        return const BorderSide(width: 1, color: AppColors.appMainColor,);
                      }
                      return const BorderSide(width: 1, color: AppColors.color_C3C5C8,);
                    },
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (value) {
                    setState(() {
                      _socialMediaValues[index]["value"] = value;
                      if (_selectedSocialMedia
                          .contains(_socialMediaValues[index])) {
                        _selectedSocialMedia.remove(_socialMediaValues[index]);
                      } else {
                        _selectedSocialMedia.add(_socialMediaValues[index]);
                      }
                    });
                  },
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
                  style:
                  AppTxtStyles.btnTxtStyle.copyWith(color: Colors.black),
                )
              ],
            )
          ),
        )
      ]),
    );
  }

  Widget _getSubmitBtn() {
    return ButtonPrimaryWidget(
      AppStrings.submit,
      onTap: () {
        if (_validateInputs()) {
          _registerBloc.add(const SendRegisterRequestEvent());
        }
      },
    );
  }

  bool _validateInputs() {
    if (_aboutCon.text.isEmpty ||
        _birthDateCon.text.isEmpty ||
        _selectedSkillsIds.isEmpty ||
        _selectedSocialMedia.isEmpty ||
        _avatarFilePath.isEmpty) {
      _registerBloc.add(const UpdateIsValidFormEvent(
          isValid: false, formErrorMsg: AppStrings.errorFillAllFieldsError));
      return false;
    } else {
      if (_aboutCon.text.length < 10) {
        _registerBloc.add(const UpdateIsValidFormEvent(
            isValid: false, formErrorMsg: AppStrings.errorAboutLength));
        return false;
      } else {
        _registerBloc.add(const UpdateIsValidFormEvent(isValid: true));
        RegisterRequestModel firstStepInfo =
            _registerBloc.state.registerRequestModel!;
        List<String> socialMedia = [];
        for (dynamic s in _selectedSocialMedia) {
          socialMedia.add(s["label"].toString().toLowerCase());
        }
        _registerBloc.add(UpdateRegisterRequestModelEvent(
            registerRequestModel: RegisterRequestModel(
                firstName: firstStepInfo.firstName,
                lastName: firstStepInfo.lastName,
                email: firstStepInfo.email,
                password: firstStepInfo.password,
                passwordConf: firstStepInfo.passwordConf,
                type: firstStepInfo.type,
                about: _aboutCon.text,
                salary: _salary,
                birthDate: _birthDateCon.text,
                gender: _userGender,
                tags: _selectedSkillsIds,
                favSocialMedia: socialMedia,
                avatar: dio.MultipartFile.fromFileSync(_avatarFilePath,
                    filename: _avatarFileName))));
        return true;
      }
    }
  }
}
