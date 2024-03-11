import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../data/model/login/login_request_model.dart';
import '../../../data/model/login/login_response_model.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginResponseModel?>> login(
      {required LoginRequestModel body});
}
