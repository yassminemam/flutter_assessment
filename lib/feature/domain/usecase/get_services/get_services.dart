import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../data/model/home/services_response_model.dart';
import '../../repository/home/home_repository.dart';

class GetServices implements UseCase<ServicesResponseModel?, NoParams> {
  final HomeRepository homeRepository;

  GetServices({required this.homeRepository});

  @override
  Future<Either<Failure, ServicesResponseModel?>> call(NoParams noParams) async {
    return await homeRepository.getServices();
  }
}
class GetPopularServices implements UseCase<ServicesResponseModel?, NoParams> {
  final HomeRepository homeRepository;

  GetPopularServices({required this.homeRepository});

  @override
  Future<Either<Failure, ServicesResponseModel?>> call(NoParams noParams) async {
    return await homeRepository.getPopularServices();
  }
}