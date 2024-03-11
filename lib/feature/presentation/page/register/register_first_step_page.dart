import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_assessment/feature/data/model/register/register_request_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/constants/strings/app_strings.dart';
import '../../../data/model/dependencies/dependencies_response_model.dart';
import '../../bloc/register/register_bloc.dart';
import '../../bloc/register/register_event.dart';
import '../../bloc/register/register_state.dart';
import '../../widget/button_primary_widget.dart';
import '../../widget/input_widget.dart';

class RegisterFirstStepPage extends StatefulWidget {
  Function() goToNext;

  RegisterFirstStepPage({super.key, required this.goToNext});

  @override
  State<RegisterFirstStepPage> createState() => _RegisterFirstStepPageState();
}

class _RegisterFirstStepPageState extends State<RegisterFirstStepPage> {
  final TextEditingController _firstNameCon = TextEditingController();
  final TextEditingController _lastNameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _passwordConfirmCon = TextEditingController();
  int _userTypeIndex = 0;
  UserType? _userType;
  late final RegisterBloc _registerBloc;

  @override
  void initState() {
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    if (_registerBloc.state.registerRequestModel != null) {
      if (_registerBloc.state.registerRequestModel!.type != null &&
          _registerBloc.state.dependencies != null) {
        _userTypeIndex = _registerBloc.state.registerRequestModel!.type!;
        _userType =
            _registerBloc.state.dependencies!.data?.types?[_userTypeIndex - 1];
      }
      _firstNameCon.text =
          _registerBloc.state.registerRequestModel!.firstName ?? "";
      _lastNameCon.text =
          _registerBloc.state.registerRequestModel!.lastName ?? "";
      _emailCon.text = _registerBloc.state.registerRequestModel!.email ?? "";
      _passwordCon.text =
          _registerBloc.state.registerRequestModel!.password ?? "";
      _passwordConfirmCon.text =
          _registerBloc.state.registerRequestModel!.passwordConf ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        if (state.status == RegisterStates.loaded) {
          return _getScreenBody();
        }
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.appMainColor,
          ),
        );
      },
    );
  }

  Widget _getScreenBody() {
    return SingleChildScrollView(
        child: Column(
      children: [
        _getRegisterForm(),
        _getUserType(),
        _getNextBtn(),
        SizedBox(
          height: 50.h,
        )
      ],
    ));
  }

  Widget _getRegisterForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InputWidget(
                title: AppStrings.firstName,
                maxLines: 1,
                controller: _firstNameCon,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ],
                margin: EdgeInsets.only(
                    top: 10.h, left: 20.w, bottom: 10.h, right: 5.w),
              ),
            ),
            Expanded(
              child: InputWidget(
                title: AppStrings.lastName,
                controller: _lastNameCon,
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ],
                margin: EdgeInsets.only(
                    top: 10.h, left: 5.w, bottom: 10.h, right: 20.w),
              ),
            ),
          ],
        ),
        InputWidget(
          title: AppStrings.emailAddress,
          controller: _emailCon,
          validator: ValidationType.EMAIL,
          maxLines: 1,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
          inputFormatters: [
            LengthLimitingTextInputFormatter(64),
          ],
        ),
        InputWidget(
          title: AppStrings.password,
          controller: _passwordCon,
          obscureText: true,
          maxLines: 1,
          suffixIcon: SvgPicture.asset('assets/icon/password_ic.svg',
              width: 18.w, height: 18.h, fit: BoxFit.scaleDown),
        ),
        InputWidget(
          title: AppStrings.confirmPassword,
          controller: _passwordConfirmCon,
          obscureText: true,
          maxLines: 1,
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

  Widget _getNextBtn() {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: ButtonPrimaryWidget(
        AppStrings.next,
        paddingHorizontal: 13,
        paddingVertical: 18,
        width: 160,
        onTap: () {
          if (_validateInputs()) {
            widget.goToNext.call();
          }
        },
      ),
    );
  }

  bool _validateInputs() {
    if (_firstNameCon.text.isEmpty ||
        _lastNameCon.text.isEmpty ||
        _emailCon.text.isEmpty ||
        _passwordCon.text.isEmpty ||
        _passwordConfirmCon.text.isEmpty ||
        _userTypeIndex == 0) {
      _registerBloc.add(const UpdateIsValidFormEvent(
          isValid: false,
          formErrorMsg: AppStrings.errorFillAllFieldsError));
      return false;
    } else {
      if (_passwordCon.text.length < 8 ||
          _passwordConfirmCon.text.length < 8) {
        _registerBloc.add(const UpdateIsValidFormEvent(
            isValid: false,
            formErrorMsg: AppStrings.errorPasswordLength));
        return false;
      } else if (_passwordCon.text != _passwordConfirmCon.text) {
        _registerBloc.add(const UpdateIsValidFormEvent(
            isValid: false,
            formErrorMsg: AppStrings.errorPasswordNotMatching));
        return false;
      } else {
        _registerBloc.add(const UpdateIsValidFormEvent(isValid: true));
        _registerBloc.add(UpdateRegisterRequestModelEvent(
            registerRequestModel: RegisterRequestModel(
                firstName: _firstNameCon.text,
                lastName: _lastNameCon.text,
                email: _emailCon.text,
                password: _passwordCon.text,
                passwordConf: _passwordConfirmCon.text,
                type: _userTypeIndex)));
        return true;
      }
    }
  }
}
