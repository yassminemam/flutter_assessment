import 'package:bloc/bloc.dart';
import '../../../domain/repository/dependencies/dependencies_repository.dart';
import 'dependencies_event.dart';
import 'dependencies_state.dart';

class DependenciesBloc extends Bloc<DependenciesEvent, DependenciesState> {
  DependenciesBloc({
    required this.getDependenciesRepo,
  }) : super(const DependenciesState()) {
    on<GetDependenciesEvent>(_mapGetDependenciesEventToState);
  }

  final DependenciesRepository getDependenciesRepo;

  void _mapGetDependenciesEventToState(
      GetDependenciesEvent event, Emitter<DependenciesState> emit) async {
    emit(
      state.copyWith(
        status: DependenciesStates.loading,
      ),
    );
    await getDependenciesRepo.getDependencies().then((result) {
      result.fold((l) {
        emit(
          state.copyWith(
            status: DependenciesStates.failure,
            error: l,
          ),
        );
      }, (r) {
        emit(
          state.copyWith(
            status: DependenciesStates.loaded,
            dependencies: r,
          ),
        );
      });
    });
  }
}
