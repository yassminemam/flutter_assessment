import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/constants/colors/app_colors.dart';
import 'package:flutter_assessment/core/theme/text_styles.dart';
import 'package:flutter_assessment/feature/presentation/page/register/register_first_step_page.dart';
import 'package:flutter_assessment/feature/presentation/page/register/register_second_step_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/strings/app_strings.dart';
import '../../../../core/util/lock_overlay.dart';
import '../../../../core/util/tools.dart';
import '../../bloc/register/register_bloc.dart';
import '../../bloc/register/register_event.dart';
import '../../bloc/register/register_state.dart';
import '../../widget/step_progress_view.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final int _allStepsCount = 2;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        key: scaffoldKey,
        body: BlocListener<RegisterBloc, RegisterState>(
          listener: (BuildContext context, RegisterState state) {
            if (state.status == RegisterStates.loading) {
              LockOverlay().showLoadingOverlay(scaffoldKey.currentContext);
            } else if (state.status == RegisterStates.failure) {
              LockOverlay().closeOverlay();
              Tools.showErrorMessage(AppStrings.errorNoInternetConnection);
            } else if (state.status == RegisterStates.loaded) {
              LockOverlay().closeOverlay();
            } else if (state.status == RegisterStates.registerSuccess) {
              LockOverlay().closeOverlay();
              context.go('/');
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              return SafeArea(
                  child: Column(
                children: [
                  _getHeader(),
                  Visibility(
                      visible: !(state.isValid ?? true),
                      child: _getErrorPanel(state.formErrorMsg ?? "")),
                  _getStepper(state.currentPageIndex!),
                  Expanded(child: _getScreenBody(state.currentPageIndex!)),
                ],
              ));
            },
          ),
        ));
  }

  Widget _getHeader() {
    final registerBloc = BlocProvider.of<RegisterBloc>(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 60.h, left: 20.w),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  if ((registerBloc.state.currentPageIndex! - 1) >= 1) {
                    registerBloc.add(UpdatePageEvent(
                        newIndex: registerBloc.state.currentPageIndex! - 1));
                  }
                },
                child: SvgPicture.asset(
                  'assets/icon/back_ic.svg',
                  width: 8.w,
                  height: 15.w,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                AppStrings.register,
                style: AppTxtStyles.mainFontStyle,
              )
            ],
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
      ],
    );
  }

  Widget _getErrorPanel(String error) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      padding: EdgeInsets.only(top: 6.h, left: 20.w, bottom: 6.h),
      decoration: BoxDecoration(
          color: AppColors.color_FFF0ED,
          borderRadius: BorderRadius.all(
            Radius.circular(4.r),
          )),
      child: Row(
        children: [
          SvgPicture.asset('assets/icon/error_ic.svg',
              width: 20.w, height: 20.h, fit: BoxFit.scaleDown),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
              child: Text(
            error,
            style: AppTxtStyles.subHeaderFontStyle
                .copyWith(color: AppColors.color_F56342),
          ))
        ],
      ),
    );
  }

  Widget _getStepper(int currentStep) {
    return StepProgressView(
      curStep: currentStep,
      steps: _allStepsCount,
      titles: const [AppStrings.register, AppStrings.completeData],
    );
  }

  Widget _getScreenBody(int currentStep) {
    switch (currentStep) {
      case 1:
        return RegisterFirstStepPage(
          goToNext: _goToNext,
        );
      case 2:
        return RegisterSecondStepPage(
          goToNext: _goToNext,
        );
    }
    return RegisterFirstStepPage(
      goToNext: _goToNext,
    );
  }

  void _goToNext() {
    final registerBloc = BlocProvider.of<RegisterBloc>(context);
    if ((registerBloc.state.currentPageIndex! + 1) <= _allStepsCount) {
      registerBloc.add(
          UpdatePageEvent(newIndex: registerBloc.state.currentPageIndex! + 1));
    }
  }
}
