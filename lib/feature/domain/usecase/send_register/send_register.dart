import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../data/model/register/register_request_model.dart';
import '../../repository/register/register_repository.dart';

class SendRegister implements UseCase<dynamic, ParamsSendRegister> {
  final RegisterRepository registerRepo;

  SendRegister({required this.registerRepo});

  @override
  Future<Either<Failure, dynamic>> call(ParamsSendRegister params) async {
    return await registerRepo.sendRegisterRequest(body: params.body);
  }

}
class ParamsSendRegister extends Equatable {
  final RegisterRequestModel body;

  const ParamsSendRegister({required this.body});

  @override
  List<Object> get props => [body];

  @override
  String toString() {
    return 'ParamsSendRegister{body: ${body.toJson()}';
  }
}