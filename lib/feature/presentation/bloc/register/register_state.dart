import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../data/model/dependencies/dependencies_response_model.dart';
import '../../../data/model/register/register_request_model.dart';

enum RegisterStates { initial, loading, loaded, failure, registerSuccess }

class RegisterState extends Equatable {
  const RegisterState(
      {this.status = RegisterStates.initial,
      this.dependencies,
      this.error,
      this.isValid = true,
      this.currentPageIndex,
      this.registerRequestModel,
      this.formErrorMsg,
      this.registerResponse});

  final DependenciesResponseModel? dependencies;
  final RegisterStates status;
  final Failure? error;
  final bool? isValid;
  final int? currentPageIndex;
  final RegisterRequestModel? registerRequestModel;
  final String? formErrorMsg;
  final dynamic registerResponse;

  @override
  List<Object?> get props => [
        status,
        dependencies,
        error,
        isValid,
        currentPageIndex,
        registerRequestModel,
        formErrorMsg,
        registerResponse
      ];

  RegisterState copyWith(
      {required RegisterStates status,
      DependenciesResponseModel? dependencies,
      Failure? error,
      bool? isValid,
      int? currentPageIndex,
      String? formErrorMsg,
      RegisterRequestModel? registerRequestModel,
      dynamic registerResponse}) {
    return RegisterState(
        status: status,
        dependencies: dependencies,
        isValid: isValid,
        currentPageIndex: currentPageIndex,
        registerRequestModel: registerRequestModel,
        formErrorMsg: formErrorMsg,
        registerResponse: registerResponse,
        error: error ?? ConnectionFailure());
  }
}
