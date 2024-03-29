import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../config/end_poits.dart';
import '../../../../core/constants/strings/app_strings.dart';
import '../../../../core/error/app_server_error.dart';
import '../../../../core/error/exception.dart';
import '../../model/login/login_request_model.dart';
import '../../model/login/login_response_model.dart';

abstract class LoginRemoteDataSource {
  Future<dynamic> sendLoginRequest({required LoginRequestModel body});
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final Dio dio;

  LoginRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<LoginResponseModel?> sendLoginRequest(
      {required LoginRequestModel body}) async {
    try {
      dio.options.headers['Content-Type'] = "application/json";
      var response =
          await dio.post(EndPoints.loginUser, data: jsonEncode(body.toJson()));
      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      }
    } on DioException catch (ex) {
      AppServerError? error =
          AppServerError.fromJson(ex.response?.data ?? ex.message);
      throw AppException(error?.toString() ??
          ex.response?.data.toString() ??
          AppStrings.unknownServerError);
    }
    return null;
  }
}
