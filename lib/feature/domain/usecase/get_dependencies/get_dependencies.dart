import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../data/model/dependencies/dependencies_response_model.dart';
import '../../repository/dependencies/dependencies_repository.dart';

class GetDependencies implements UseCase<DependenciesResponseModel, NoParams> {
  final DependenciesRepository getDependenciesRepo;

  GetDependencies({required this.getDependenciesRepo});

  @override
  Future<Either<Failure, DependenciesResponseModel?>> call(NoParams params) async {
    return await getDependenciesRepo.getDependencies();
  }

}