import 'package:dartz/dartz.dart';
import 'package:flutter_assessment/core/error/failure.dart';
import 'package:flutter_assessment/feature/data/model/login/login_request_model.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/network/network_info.dart';
import '../../../domain/repository/login/login_repository.dart';
import '../../datasource/login/login_remote_data_source.dart';
import '../../model/login/login_response_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource loginRemoteDataSource;
  final NetworkInfo networkInfo;

  LoginRepositoryImpl({
    required this.loginRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, LoginResponseModel?>> login(
      {required LoginRequestModel body}) async {
    var isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        var response = await loginRemoteDataSource.sendLoginRequest(body: body);
        return Right(response);
      } on AppException catch (exp) {
        return Left(ServerFailure(exp.errorMessage));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
