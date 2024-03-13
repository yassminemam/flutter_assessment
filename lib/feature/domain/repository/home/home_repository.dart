import 'package:dartz/dartz.dart';
import 'package:flutter_assessment/feature/data/model/home/services_response_model.dart';

import '../../../../core/error/failure.dart';
import '../../../data/model/home/countries_response_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, CountriesResponseModel?>> getCountries({int? index});
  Future<Either<Failure, ServicesResponseModel?>> getServices();
  Future<Either<Failure, ServicesResponseModel?>> getPopularServices();
}