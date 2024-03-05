import 'package:dio/dio.dart';
import '../../../config/end_poits.dart';
import '../../../injection_container.dart';
import '../model/dependencies/dependencies_response_model.dart';

abstract class DependenciesRemoteDataSource {
  Future<DependenciesResponseModel?> getDependencies();
}

class DependenciesRemoteDataSourceImpl implements DependenciesRemoteDataSource {

  final Dio dio;

  DependenciesRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<DependenciesResponseModel?> getDependencies() async {
    try {
      var response = await dio.get(
        EndPoints.getDependencies,
      );
      if (response.statusCode == 200) {
        DependenciesResponseModel dependenciesResponseModel = DependenciesResponseModel
            .fromJson(response.data);
        return dependenciesResponseModel;
      }
      return null;
    }
    on DioException catch (ex) {
      throw Exception(ex.message);
    }
  }
}