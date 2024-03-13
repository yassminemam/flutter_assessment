import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:dio/dio.dart';
import 'package:flutter_assessment/feature/domain/usecase/get_countries/get_countries.dart';
import 'package:flutter_assessment/feature/domain/usecase/get_settings/get_settings.dart';
import 'package:flutter_assessment/feature/domain/usecase/login_user/login_user.dart';
import 'package:flutter_assessment/feature/domain/usecase/update_settings/update_settings.dart';
import 'package:flutter_assessment/feature/presentation/bloc/settings/settings_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/flavour_config.dart';
import 'core/network/network_info.dart';
import 'core/util/dio_logging_interceptor.dart';
import 'feature/data/datasource/home/home_remote_data_source.dart';
import 'feature/data/datasource/login/login_remote_data_source.dart';
import 'feature/data/datasource/register/register_remote_data_source.dart';
import 'feature/data/datasource/settings/settings_local_data_source.dart';
import 'feature/data/repository/home/home_repository_impl.dart';
import 'feature/data/repository/login/login_repository_impl.dart';
import 'feature/data/repository/register/register_repository_impl.dart';
import 'feature/data/repository/settings/settings_repository_impl.dart';
import 'feature/domain/repository/home/home_repository.dart';
import 'feature/domain/repository/login/login_repository.dart';
import 'feature/domain/repository/register/register_repository.dart';
import 'feature/domain/repository/settings/settings_repository.dart';
import 'feature/domain/usecase/get_dependencies/get_dependencies.dart';
import 'feature/domain/usecase/get_services/get_services.dart';
import 'feature/domain/usecase/send_register/send_register.dart';
import 'feature/presentation/bloc/home/home_bloc.dart';
import 'feature/presentation/bloc/login/login_bloc.dart';
import 'feature/presentation/bloc/register/register_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /**
   * ! Core
   */
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  /**
   * ! External
   */
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = FlavorConfig.instance.values.baseUrl;
    Map<String, dynamic> header = {};
    header['Content-Type'] = "application/json";
    header['Accept'] = "application/json";
    header['Accept-Language'] = "ar";
    dio.options.headers = header;
    dio.interceptors.add(LoggingInterceptor());
    return dio;
  });

  sl.registerLazySingletonAsync<SharedPreferences>(() {
    final sharedPref = SharedPreferences.getInstance();
    return sharedPref;
  });
  await sl.isReady<SharedPreferences>();
  /**
   * ! Features
   */
  // Data Source
  sl.registerLazySingleton<RegisterRemoteDataSource>(
      () => RegisterRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(sharedPref: sl()));
  sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(dio: sl()));

  // Repository
  sl.registerLazySingleton<RegisterRepository>(() => RegisterRepositoryImpl(
      registerRemoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<LoginRepository>(() =>
      LoginRepositoryImpl(loginRemoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(settingsLocalDataSource: sl()));
  sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(homeRemoteDataSource: sl(), networkInfo: sl()));
  // Use Case
  sl.registerLazySingleton(() => GetDependencies(registerRepo: sl()));
  sl.registerLazySingleton(() => SendRegister(registerRepo: sl()));
  sl.registerLazySingleton(() => LoginUser(loginRepo: sl()));
  sl.registerLazySingleton(() => UpdateSettings(settingsRepo: sl()));
  sl.registerLazySingleton(() => GetSettings(settingsRepo: sl()));
  sl.registerLazySingleton(() => GetCountries(homeRepository: sl()));
  sl.registerLazySingleton(() => GetServices(homeRepository: sl()));
  // Bloc
  sl.registerFactory(
    () => RegisterBloc(
      getDependencies: sl(),
      sendRegister: sl(),
    ),
  );
  sl.registerFactory(
    () => LoginBloc(loginUser: sl()),
  );
  sl.registerFactory(
    () => SettingsBloc(
      updateSettings: sl(),
      getSettings: sl(),
    ),
  );
  sl.registerFactory(() => HomeBloc(getCountries: sl(), getServices: sl(),));
}
