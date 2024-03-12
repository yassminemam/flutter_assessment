import 'package:dartz/dartz.dart';
import 'package:flutter_assessment/core/error/failure.dart';
import 'package:flutter_assessment/feature/data/model/home/countries_response_model.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/network/network_info.dart';
import '../../../domain/repository/home/home_repository.dart';
import '../../datasource/home/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.homeRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CountriesResponseModel?>> getCountries({int? index}) async {
    var isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        var response = await homeRemoteDataSource.getCountries(pageIndex: index);
        return Right(response);
      } on AppException catch (exp) {
        return Left(ServerFailure(exp.errorMessage));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}