import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_assessment/feature/data/model/login/login_response_model.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../data/model/login/login_request_model.dart';
import '../../repository/login/login_repository.dart';

class LoginUser implements UseCase<LoginResponseModel, ParamsLoginUser> {
  final LoginRepository loginRepo;

  LoginUser({required this.loginRepo});

  @override
  Future<Either<Failure, LoginResponseModel?>> call(ParamsLoginUser params) async {
    return await loginRepo.login(body: params.body);
  }

}
class ParamsLoginUser extends Equatable {
  final LoginRequestModel body;

  const ParamsLoginUser({required this.body});

  @override
  List<Object> get props => [body];

  @override
  String toString() {
    return 'ParamsLoginUser{body: ${body.toJson()}';
  }
}