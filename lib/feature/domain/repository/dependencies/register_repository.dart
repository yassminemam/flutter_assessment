import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../data/model/dependencies/dependencies_response_model.dart';
import '../../../data/model/register/register_request_model.dart';

abstract class RegisterRepository {
  Future<Either<Failure, DependenciesResponseModel?>> getDependencies();
  Future<Either<Failure, dynamic>> sendRegisterRequest({required RegisterRequestModel body});
}