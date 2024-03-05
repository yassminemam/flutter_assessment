import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'config/flavour_config.dart';
import 'core/network/network_info.dart';
import 'core/util/dio_logging_interceptor.dart';
import 'feature/data/dependencies/dependencies_remote_data_source.dart';
import 'feature/data/repository/dependencies/dependencies_repository_impl.dart';
import 'feature/domain/repository/dependencies/dependencies_repository.dart';
import 'feature/domain/usecase/get_dependencies/get_dependencies.dart';
import 'feature/presentation/bloc/dependencies/dependencies_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /**
   * ! Features
   */
  // Bloc
  sl.registerFactory(
    () => DependenciesBloc(
      getDependenciesRepo: sl(),
    ),
  );

  // Use Case
  sl.registerLazySingleton(() => GetDependencies(getDependenciesRepo: sl()));

  // Repository
  sl.registerLazySingleton<DependenciesRepository>(
      () => DependenciesRepositoryImpl(dependenciesRemoteDataSource: sl(), networkInfo: sl()));

  // Data Source
  sl.registerLazySingleton<DependenciesRemoteDataSource>(
      () => DependenciesRemoteDataSourceImpl(dio: sl()));

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
