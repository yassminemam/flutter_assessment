import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/constants/colors/app_colors.dart';
import 'package:flutter_assessment/core/theme/text_styles.dart';
import 'package:flutter_assessment/feature/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../app_router.dart';
import '../../../../core/constants/strings/app_strings.dart';
import '../../../../core/util/lock_overlay.dart';
import '../../../../core/util/tools.dart';
import '../../bloc/login/login_state.dart';
import '../../widget/button_primary_widget.dart';
import '../../widget/input_widget.dart';
import '../../widget/sub_txt_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  String email = "";
  String password = "";
  late LoginBloc loginBloc;

  @override
  void initState() {
    loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: BlocProvider<LoginBloc>(
          create: (context) => loginBloc,
          child: BlocListener<LoginBloc, LoginState>(
            listener: (BuildContext context, LoginState state) {
              if (state.status == LoginStates.loading) {
                LockOverlay().showLoadingOverlay(scaffoldKey.currentContext);
              } else if (state.status == LoginStates.failure) {
                LockOverlay().closeOverlay();
                Tools.showErrorMessage(AppStrings.errorNoInternetConnection);
              } else if (state.status == LoginStates.loaded) {
                LockOverlay().closeOverlay();
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state.status == LoginStates.initial) {
                  return SafeArea(child: _getScreenBody());
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.appMainColor,
                  ),
                );
              },
            ),
          )),
    );
  }

  Widget _getScreenBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _getHeader(),
          _getEmailPasswordForm(),
          _getLoginBtn(),
          _getFooter(),
          SizedBox(
            height: 40.h,
          )
        ],
      ),
    );
  }

  Widget _getHeader() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 60.h, left: 20.w),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icon/back_ic.svg',
                width: 8.w,
                height: 15.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                AppStrings.accountLogin,
                style: AppTxtStyles.mainFontStyle,
              )
            ],
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
        SvgPicture.asset(
          'assets/bg/login_bg.svg',
          width: 225.w,
          height: 225.h,
        ),
      ],
    );
  }

  Widget _getEmailPasswordForm() {
    return Column(
      children: [
        SizedBox(
          height: 30.h,
        ),
        InputWidget(
          title: AppStrings.emailAddress,
          controller: emailCon,
          validator: ValidationType.EMAIL,
          maxLines: 1,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.w),
          onDone: (email) {
            this.email = email;
          },
        ),
        InputWidget(
          title: AppStrings.password,
          controller: passwordCon,
          maxLines: 1,
          onDone: (password) {
            this.password = password;
          },
          obscureText: true,
          validator: ValidationType.TEXT,
          suffixIcon: SvgPicture.asset('assets/icon/password_ic.svg',
              width: 18.w, height: 18.h, fit: BoxFit.scaleDown),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 10.w,
            ),
            Checkbox(
              activeColor: AppColors.appMainColor,
              checkColor: Colors.white,
              value: true,
              onChanged: (isChecked) {}, //  <-- leading Checkbox
            ),
            SubTxtWidget(AppStrings.rememberMe),
            const Spacer(),
            SubTxtWidget(AppStrings.forgotPassword),
            SizedBox(
              width: 20.w,
            ),
          ],
        ),
      ],
    );
  }

  Widget _getLoginBtn() {
    return ButtonPrimaryWidget(
      AppStrings.login,
      onTap: () {},
    );
  }

  Widget _getFooter() {
    return InkWell(
      onTap: () {
        context.go('/$registerRoute');
      },
      child: Center(
        child: RichText(
          text: TextSpan(
            style: AppTxtStyles.subHeaderFontStyle
                .copyWith(fontWeight: FontWeight.w500, fontSize: 14.sp),
            children: <TextSpan>[
              const TextSpan(
                text: AppStrings.doNotHaveAccount,
              ),
              TextSpan(
                  text: " ${AppStrings.register}",
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.appMainColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: "montserrat_regular")),
            ],
          ),
        ),
      ),
    );
  }
}
