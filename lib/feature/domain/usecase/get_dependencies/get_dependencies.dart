import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../data/model/dependencies/dependencies_response_model.dart';
import '../../repository/dependencies/register_repository.dart';

class GetDependencies implements UseCase<DependenciesResponseModel, NoParams> {
  final RegisterRepository registerRepo;

  GetDependencies({required this.registerRepo});

  @override
  Future<Either<Failure, DependenciesResponseModel?>> call(NoParams params) async {
    return await registerRepo.getDependencies();
  }

}