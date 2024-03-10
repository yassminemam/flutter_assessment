import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../data/model/dependencies/dependencies_response_model.dart';

enum LoginStates { initial, loading, loaded, failure }
extension LoginStatesX on LoginStates {
  bool get isInitial => this == LoginStates.initial;
  bool get isLoaded => this == LoginStates.loaded;
  bool get isFailure => this == LoginStates.failure;
  bool get isLoading => this == LoginStates.loading;
}
class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStates.initial,
    this.dependencies, this.error,
  });

  final DependenciesResponseModel? dependencies;
  final LoginStates status;
  final Failure? error;
  @override
  List<Object?> get props => [status, dependencies];

  LoginState copyWith({
    DependenciesResponseModel? dependencies,
    required LoginStates status,
    Failure? error
  }) {
    return LoginState(
        dependencies: dependencies,
        status: status,
        error: error ?? ConnectionFailure()
    );
  }
}