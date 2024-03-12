import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../data/model/home/countries_response_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, CountriesResponseModel?>> getCountries();

}