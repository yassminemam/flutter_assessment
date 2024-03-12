import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioLib;
import 'package:flutter_assessment/core/error/app_server_error.dart';
import '../../../../config/end_poits.dart';
import '../../../../core/error/exception.dart';
import '../../model/dependencies/dependencies_response_model.dart';
import '../../model/register/register_request_model.dart';

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
    } on DioException catch (ex) {
      AppServerError? error =
          AppServerError.fromJson(ex.response?.data ?? ex.message);
      throw AppException(error?.toString() ?? "Unknown Server Error");
    }
    return null;
  }

  @override
  Future<dynamic> sendRegisterRequest(
      {required RegisterRequestModel body}) async {
    try {
      dio.options.headers['Content-Type'] = "multipart/form-data";
      dioLib.FormData formDataBody =
          dioLib.FormData.fromMap(body.toJson(), ListFormat.multiCompatible);
      var response = await dio.post(EndPoints.sendRegister, data: formDataBody);
      if (response.statusCode == 200) {
        return response;
      }
    } on DioException catch (ex) {
      AppServerError? error =
      AppServerError.fromJson(ex.response?.data ?? ex.message);
      throw AppException(error?.toString() ?? "Unknown Server Error");
    }
  }
}
