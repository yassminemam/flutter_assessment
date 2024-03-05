import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_assessment/core/error/failure.dart';
import 'package:flutter_assessment/feature/data/model/dependencies/dependencies_response_model.dart';
import '../../../../core/network/network_info.dart';
import '../../../domain/repository/dependencies/dependencies_repository.dart';
import '../../dependencies/dependencies_remote_data_source.dart';

class DependenciesRepositoryImpl implements DependenciesRepository {
  final DependenciesRemoteDataSource dependenciesRemoteDataSource;
  final NetworkInfo networkInfo;

  DependenciesRepositoryImpl({
    required this.dependenciesRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DependenciesResponseModel?>> getDependencies() async {
    var isConnected = await networkInfo.isConnected ?? false;
    if (isConnected) {
      try {
        var response = await dependenciesRemoteDataSource.getDependencies();
        return Right(response);
      } on DioException catch (exp) {
        return Left(ServerFailure(exp.message??"Unknown Error"));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

}