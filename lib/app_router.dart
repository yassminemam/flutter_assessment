import 'package:flutter/material.dart';
import 'package:flutter_assessment/feature/presentation/bloc/settings/settings_bloc.dart';
import 'package:flutter_assessment/feature/presentation/bloc/settings/settings_event.dart';
import 'package:flutter_assessment/feature/presentation/bloc/settings/settings_state.dart';
import 'package:flutter_assessment/feature/presentation/page/home/home_page.dart';
import 'package:flutter_assessment/feature/presentation/page/register/register_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/colors/app_colors.dart';
import 'feature/presentation/page/login/login_page.dart';

const String registerRoute = 'register';
const String homeRoute = "home";
List<RouteBase> allRouts = <RouteBase>[
  GoRoute(
    path: '/',
    builder: (BuildContext context, GoRouterState state) {
      SettingsBloc settingsBloc = BlocProvider.of<SettingsBloc>(context);
      settingsBloc.add(const GetSettingsEvent());
      return BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (prev, current) =>
            ((current.status != SettingsStates.initial) &&
                (current.status != SettingsStates.loading)),
        builder: (context, state) {
          if (state.status == SettingsStates.success) {
            if (settingsBloc.state.settingsModel != null &&
                settingsBloc.state.settingsModel!.isLogin) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          }
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.appMainColor,
            ),
          );
        },
      );
    },
    routes: <RouteBase>[
      GoRoute(
        path: registerRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPage();
        },
      ),
      GoRoute(
        path: homeRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
    ],
  ),
];
