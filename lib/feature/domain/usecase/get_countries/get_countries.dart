import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../data/model/home/countries_response_model.dart';
import '../../repository/home/home_repository.dart';

class GetCountries implements UseCase<CountriesResponseModel, ParamsGetCountries> {
  final HomeRepository homeRepository;

  GetCountries({required this.homeRepository});

  @override
  Future<Either<Failure, CountriesResponseModel?>> call(ParamsGetCountries params) async {
    return await homeRepository.getCountries(index: params.pageIndex);
  }
}
class ParamsGetCountries extends Equatable {
  final int? pageIndex;

  const ParamsGetCountries({required this.pageIndex});

  @override
  List<Object?> get props => [pageIndex];

  @override
  String toString() {
    return 'ParamsGetCountries{pageIndex: $pageIndex';
  }
}