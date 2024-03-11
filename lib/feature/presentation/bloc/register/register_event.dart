import 'package:equatable/equatable.dart';

import '../../../data/model/register/register_request_model.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class GetDependenciesEvent extends RegisterEvent {
  const GetDependenciesEvent();

  @override
  List<Object> get props => [];

}

class UpdateIsValidFormEvent extends RegisterEvent {
  final bool isValid;
  final String? formErrorMsg;
  const UpdateIsValidFormEvent({required this.isValid, this.formErrorMsg});

  @override
  List<Object?> get props => [isValid, formErrorMsg];
}

class UpdatePageEvent extends RegisterEvent {
  final int newIndex;
  final RegisterRequestModel? registerRequestModel;
  const UpdatePageEvent({required this.newIndex, this.registerRequestModel});

  @override
  List<Object?> get props => [newIndex, registerRequestModel];
}

class UpdateRegisterRequestModelEvent extends RegisterEvent {
  final RegisterRequestModel registerRequestModel;
  const UpdateRegisterRequestModelEvent({required this.registerRequestModel});

  @override
  List<Object> get props => [registerRequestModel];
}

class SendRegisterRequestEvent extends RegisterEvent {
  const SendRegisterRequestEvent();

  @override
  List<Object> get props => [];
}