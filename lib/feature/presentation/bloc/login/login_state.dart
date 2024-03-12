import 'package:equatable/equatable.dart';
import 'package:flutter_assessment/feature/data/model/login/login_request_model.dart';
import 'package:flutter_assessment/feature/data/model/login/login_response_model.dart';
import '../../../../core/error/failure.dart';

enum LoginStates { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStates.initial,
    this.error,
    this.body,
    this.loginResponse
  });
  final LoginStates status;
  final Failure? error;
  final LoginRequestModel? body;
  final LoginResponseModel? loginResponse;
  @override
  List<Object?> get props => [status, error, loginResponse];

  LoginState copyWith({
    required LoginStates status,
    Failure? error,
    LoginRequestModel? body,
    LoginResponseModel? loginResponse
  }) {
    return LoginState(
        status: status,
        body: body,
        loginResponse: loginResponse,
        error: error ?? ConnectionFailure()
    );
  }
}