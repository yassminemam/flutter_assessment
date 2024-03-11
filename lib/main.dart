import 'package:flutter/material.dart';
import 'package:flutter_assessment/core/constants/colors/app_colors.dart';
import 'package:flutter_assessment/feature/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_assessment/feature/presentation/bloc/settings/settings_bloc.dart';
import 'package:flutter_assessment/injection_container.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';
import 'config/base_url_config.dart';
import 'config/flavour_config.dart';
import 'core/util/tools.dart';
import 'feature/presentation/bloc/home/home_bloc.dart';
import 'feature/presentation/bloc/register/register_bloc.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig(
    flavor: Flavor.DEVELOPMENT,
    values: FlavorValues(baseUrl: BaseUrlConfig().baseUrlDevelopment),
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<RegisterBloc>(
            create: (context) => sl<RegisterBloc>(),
          ),
          BlocProvider<LoginBloc>(
            create: (context) => sl<LoginBloc>(),
          ),
          BlocProvider<SettingsBloc>(
            create: (context) => sl<SettingsBloc>(),
          ),
          BlocProvider<HomeBloc>(create: (context) => sl<HomeBloc>()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme:
                  const ColorScheme.light(primary: AppColors.appMainColor),
              buttonTheme:
                  const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            routerConfig:
                GoRouter(routes: allRouts, navigatorKey: Tools.navigatorKey),
          ),
        ));
  }
}
