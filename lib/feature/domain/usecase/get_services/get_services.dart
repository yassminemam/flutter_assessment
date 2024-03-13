import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../data/model/home/services_response_model.dart';
import '../../repository/home/home_repository.dart';

class GetServices implements UseCase<ServicesResponseModel?, ParamsGetServices> {
  final HomeRepository homeRepository;

  GetServices({required this.homeRepository});

  @override
  Future<Either<Failure, ServicesResponseModel?>> call(ParamsGetServices params) async {
    return await homeRepository.getServices(isPopular: params.isPopular);
  }
}
class ParamsGetServices extends Equatable {
  final bool isPopular;

  const ParamsGetServices({required this.isPopular});

  @override
  List<Object> get props => [isPopular];

  @override
  String toString() {
    return 'ParamsGetServices{isPopular: $isPopular';
  }
}