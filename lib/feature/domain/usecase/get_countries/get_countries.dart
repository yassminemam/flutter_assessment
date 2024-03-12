import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../data/model/home/countries_response_model.dart';
import '../../repository/home/home_repository.dart';

class GetCountries implements UseCase<CountriesResponseModel, NoParams> {
  final HomeRepository homeRepository;

  GetCountries({required this.homeRepository});

  @override
  Future<Either<Failure, CountriesResponseModel?>> call(NoParams params) async {
    return await homeRepository.getCountries();
  }
}