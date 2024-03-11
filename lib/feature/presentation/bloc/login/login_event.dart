import 'package:equatable/equatable.dart';
import 'package:flutter_assessment/feature/data/model/login/login_request_model.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginUserEvent extends LoginEvent {
  final LoginRequestModel body;
  const LoginUserEvent({required this.body});

  @override
  List<Object?> get props => [body];

}