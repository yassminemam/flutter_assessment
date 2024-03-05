import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../data/model/dependencies/dependencies_response_model.dart';

enum DependenciesStates { initial, loading, loaded, failure }
extension DependenciesStatesX on DependenciesStates {
  bool get isInitial => this == DependenciesStates.initial;
  bool get isLoaded => this == DependenciesStates.loaded;
  bool get isFailure => this == DependenciesStates.failure;
  bool get isLoading => this == DependenciesStates.loading;
}
class DependenciesState extends Equatable {
  const DependenciesState({
    this.status = DependenciesStates.initial,
    this.dependencies, this.error,
  });

  final DependenciesResponseModel? dependencies;
  final DependenciesStates status;
  final Failure? error;
  @override
  List<Object?> get props => [status, dependencies];

  DependenciesState copyWith({
    DependenciesResponseModel? dependencies,
    required DependenciesStates status,
    Failure? error
  }) {
    return DependenciesState(
        dependencies: dependencies,
        status: status,
        error: error ?? ConnectionFailure()
    );
  }
}