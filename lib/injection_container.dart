import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'config/flavour_config.dart';
import 'core/network/network_info.dart';
import 'core/util/dio_logging_interceptor.dart';
import 'feature/data/dependencies/register_remote_data_source.dart';
import 'feature/data/repository/register/register_repository_impl.dart';
import 'feature/domain/repository/dependencies/register_repository.dart';
import 'feature/domain/usecase/get_dependencies/get_dependencies.dart';
import 'feature/presentation/bloc/login/login_bloc.dart';
import 'feature/presentation/bloc/register/register_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /**
   * ! Features
   */
  // Bloc
  sl.registerFactory(
    () => RegisterBloc(
      registerRepo: sl(),
    ),
  );
  sl.registerFactory(
    () => LoginBloc(),
  );

  // Use Case
  sl.registerLazySingleton(() => GetDependencies(registerRepo: sl()));

  // Repository
  sl.registerLazySingleton<RegisterRepository>(() =>
      RegisterRepositoryImpl(
          registerRemoteDataSource: sl(), networkInfo: sl()));

  // Data Source
  sl.registerLazySingleton<RegisterRemoteDataSource>(
      () => RegisterRemoteDataSourceImpl(dio: sl()));

  /**
   * ! Core
   */
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
  sl.registerLazySingleton(() => DataConnectionChecker());
}
