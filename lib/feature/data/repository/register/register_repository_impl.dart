import 'package:dartz/dartz.dart';
import 'package:flutter_assessment/core/error/failure.dart';
import 'package:flutter_assessment/feature/data/model/dependencies/dependencies_response_model.dart';
import '../../../../core/constants/strings/app_strings.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/network/network_info.dart';
import '../../../domain/repository/register/register_repository.dart';
import '../../datasource/register/register_remote_data_source.dart';
import '../../model/register/register_request_model.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource registerRemoteDataSource;
  final NetworkInfo networkInfo;

  RegisterRepositoryImpl({
    required this.registerRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DependenciesResponseModel?>> getDependencies() async {
    var isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        var response = await registerRemoteDataSource.getDependencies();
        return response == null
            ? Left(ServerFailure(AppStrings.dataFromServerIsNullError))
            :  Right(response);
      } on AppException catch (exp) {
        return Left(ServerFailure(exp.errorMessage));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, dynamic>> sendRegisterRequest({required RegisterRequestModel body}) async {
    var isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        var response = await registerRemoteDataSource.sendRegisterRequest(body: body);
        return Right(response);
      } on AppException catch (exp) {
        return Left(ServerFailure(exp.errorMessage));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

}