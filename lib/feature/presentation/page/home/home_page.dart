import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/constants/colors/app_colors.dart';
import 'package:flutter_assessment/feature/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_assessment/feature/presentation/bloc/register/register_bloc.dart';
import 'package:flutter_assessment/feature/presentation/page/home/profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/constants/strings/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/util/lock_overlay.dart';
import '../../../../core/util/tools.dart';
import '../../../data/model/dependencies/dependencies_response_model.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_state.dart';
import '../../bloc/login/login_state.dart';
import '../../widget/input_widget.dart';
import '../../widget/sub_txt_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        body: BlocProvider<HomeBloc>(
            create: (context) => _homeBloc,
            child: BlocListener<HomeBloc, HomeState>(
              listener: (BuildContext context, HomeState state) {
                if (state.status == HomeStates.loading) {
                  LockOverlay().showLoadingOverlay(_scaffoldKey.currentContext);
                } else if (state.status == HomeStates.failure) {
                  LockOverlay().closeOverlay();
                  Tools.showErrorMessage(state.error?.errorMessage);
                } else if (state.status == HomeStates.success) {
                  LockOverlay().closeOverlay();
                }
              },
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return SafeArea(child: _getScreenBody());
                },
              ),
            )),
        bottomNavigationBar: _getBottomNavigationBar());
  }

  Widget _getScreenBody() {
    return const ProfilePage();
  }

  Widget _getBottomNavigationBar() {
    return Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    'assets/icon/bar/profile_active_ic.svg',
                    width: 26.w,
                    height: 26.h,
                    colorFilter: const ColorFilter.mode(
                        AppColors.appMainColor, BlendMode.srcIn),
                  ),
                  icon: SvgPicture.asset(
                    'assets/icon/bar/profile_ic.svg',
                    colorFilter: const ColorFilter.mode(
                        AppColors.color_C3C5C8, BlendMode.srcIn),
                    width: 26.w,
                    height: 26.h,
                  ),
                  label: "Who am I",
                ),
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    'assets/icon/bar/countries_active_ic.svg',
                    width: 26.w,
                    height: 26.h,
                    colorFilter: const ColorFilter.mode(
                        AppColors.appMainColor, BlendMode.srcIn),
                  ),
                  icon: SvgPicture.asset(
                    'assets/icon/bar/countries_ic.svg',
                    colorFilter: const ColorFilter.mode(
                        AppColors.color_C3C5C8, BlendMode.srcIn),
                    width: 26.w,
                    height: 26.h,
                  ),
                  label: "Countries",
                ),
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    'assets/icon/bar/services_active_ic.svg',
                    colorFilter: const ColorFilter.mode(
                        AppColors.appMainColor, BlendMode.srcIn),
                    width: 22.w,
                    height: 22.h,
                  ),
                  icon: SvgPicture.asset(
                    'assets/icon/bar/services_ic.svg',
                    colorFilter: const ColorFilter.mode(
                        AppColors.color_C3C5C8, BlendMode.srcIn),
                    width: 22.w,
                    height: 22.h,
                  ),
                  label: "Services",
                ),
              ],
              currentIndex: 0,
              onTap: (int index) {},
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.appMainColor,
              unselectedItemColor: AppColors.color_C3C5C8,
              iconSize: 22.h,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              useLegacyColorScheme: false,
              type: BottomNavigationBarType.fixed,
              elevation: 20,
            );
          },
        ));
  }
}
