import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../data/model/dependencies/dependencies_response_model.dart';

abstract class DependenciesRepository {

  Future<Either<Failure, DependenciesResponseModel?>> getDependencies();

}