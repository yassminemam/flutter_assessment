import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/constants/colors/app_colors.dart';
import 'package:flutter_assessment/core/constants/strings/app_strings.dart';
import 'package:flutter_assessment/feature/presentation/bloc/home/home_event.dart';
import 'package:flutter_assessment/feature/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_assessment/feature/presentation/bloc/register/register_bloc.dart';
import 'package:flutter_assessment/feature/presentation/bloc/register/register_event.dart';
import 'package:flutter_assessment/feature/presentation/bloc/settings/settings_event.dart';
import 'package:flutter_assessment/feature/presentation/page/home/profile_page.dart';
import 'package:flutter_assessment/feature/presentation/page/home/services_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/constants/strings/app_assets.dart';
import '../../../../core/util/lock_overlay.dart';
import '../../../../core/util/tools.dart';
import '../../../data/model/settings/settings_model.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_state.dart';
import '../../bloc/register/register_state.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/settings/settings_state.dart';
import 'countries_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final RegisterBloc _registerBloc;
  late final LoginBloc _loginBloc;
  late final SettingsBloc _settingsBloc;

  @override
  void initState() {
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    if (_loginBloc.state.loginResponse == null) {
      _settingsBloc.add(UpdateSessionEvent(
          settingsModel: SettingsModel(authToken: '', isLogin: false)));
    } else if (_settingsBloc.state.status == SettingsStates.success &&
        _registerBloc.state.dependencies == null) {
      _registerBloc.add(const GetDependenciesEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.color_F8FAFC,
        body: BlocListener<RegisterBloc, RegisterState>(
          listener: (BuildContext context, RegisterState state) {
            if (state.status == RegisterStates.loading) {
              LockOverlay().showLoadingOverlay(_scaffoldKey.currentContext);
            } else if (state.status == RegisterStates.failure) {
              LockOverlay().closeOverlay();
              Tools.showErrorMessage(state.error?.errorMessage);
            } else if (state.status == RegisterStates.loaded) {
              LockOverlay().closeOverlay();
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, regState) {
              return BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (regState.dependencies != null) {
                    return SafeArea(
                        child: _getScreenBody(state.currentPageIndex ?? 0));
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appMainColor,
                    ),
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: _getBottomNavigationBar());
  }

  Widget _getScreenBody(int currentPageIndex) {
    switch (currentPageIndex) {
      case 0:
        return const ProfilePage();
      case 1:
        return const CountriesPage();
      case 2:
        return const ServicesPage();
    }
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
                    AppAssets.profile_active_ic,
                    width: 26.w,
                    height: 26.h,
                    colorFilter: const ColorFilter.mode(
                        AppColors.appMainColor, BlendMode.srcIn),
                  ),
                  icon: SvgPicture.asset(
                    AppAssets.profile_ic,
                    colorFilter: const ColorFilter.mode(
                        AppColors.color_C3C5C8, BlendMode.srcIn),
                    width: 26.w,
                    height: 26.h,
                  ),
                  label: AppStrings.profileHeader,
                ),
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                    AppAssets.countries_active_ic,
                    width: 26.w,
                    height: 26.h,
                    colorFilter: const ColorFilter.mode(
                        AppColors.appMainColor, BlendMode.srcIn),
                  ),
                  icon: SvgPicture.asset(
                    AppAssets.countries_ic,
                    colorFilter: const ColorFilter.mode(
                        AppColors.color_C3C5C8, BlendMode.srcIn),
                    width: 26.w,
                    height: 26.h,
                  ),
                  label: AppStrings.countriesHeader,
                ),
                BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset(
                  AppAssets.services_active_ic,
                    colorFilter: const ColorFilter.mode(
                        AppColors.appMainColor, BlendMode.srcIn),
                    width: 22.w,
                    height: 22.h,
                  ),
                  icon: SvgPicture.asset(
                  AppAssets.services_ic,
                    colorFilter: const ColorFilter.mode(
                        AppColors.color_C3C5C8, BlendMode.srcIn),
                    width: 22.w,
                    height: 22.h,
                  ),
                  label: AppStrings.servicesHeader,
                ),
              ],
              currentIndex: state.currentPageIndex ?? 0,
              onTap: (int index) => _changePage(index),
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

  void _changePage(int newIndex) {
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(UpdatePageEvent(newIndex: newIndex));
  }
}
