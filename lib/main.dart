import 'package:flutter/material.dart';
import 'package:flutter_assessment/injection_container.dart' as di;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/base_url_config.dart';
import 'config/flavour_config.dart';
import 'feature/presentation/page/login/login_page.dart';

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
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_ , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: child,
        );
      },
      child: const LoginPage(),
    );
  }
}
