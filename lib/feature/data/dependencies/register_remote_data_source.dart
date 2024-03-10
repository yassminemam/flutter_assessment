import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioLib;
import '../../../config/end_poits.dart';
import '../model/dependencies/dependencies_response_model.dart';
import '../model/register/register_request_model.dart';

abstract class RegisterRemoteDataSource {
  Future<DependenciesResponseModel?> getDependencies();

  Future<dynamic> sendRegisterRequest({required RegisterRequestModel body});
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  final Dio dio;

  RegisterRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<DependenciesResponseModel?> getDependencies() async {
    try {
      var response = await dio.get(
        EndPoints.getDependencies,
      );
      if (response.statusCode == 200) {
        DependenciesResponseModel dependenciesResponseModel =
            DependenciesResponseModel.fromJson(response.data);
        return dependenciesResponseModel;
      }
      return null;
    } on DioException catch (ex) {
      throw Exception(ex.message);
    }
  }

  @override
  Future<dynamic> sendRegisterRequest(
      {required RegisterRequestModel body}) async {
    try {
      Map<String, dynamic> header = {};
      header['Content-Type'] = "multipart/form-data";
      header['Accept'] = "application/json";
      header['Accept-Language'] = "ar";
      dio.options.headers = header;
      dioLib.FormData formDataBody =
          dioLib.FormData.fromMap(body.toJson(), ListFormat.multiCompatible);
      var response = await dio.post(EndPoints.sendRegister, data: formDataBody);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }
      return null;
    } on DioException catch (ex) {
      throw Exception(ex.message);
    }
  }
}
