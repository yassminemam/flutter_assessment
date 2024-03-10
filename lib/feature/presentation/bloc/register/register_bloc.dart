import 'package:bloc/bloc.dart';
import '../../../domain/repository/dependencies/register_repository.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required this.registerRepo,
  }) : super(const RegisterState()) {
    on<GetDependenciesEvent>(_mapGetDependenciesEventToState);
    on<UpdateIsValidFormEvent>(_mapUpdateIsValidFormEventToState);
    on<UpdatePageEvent>(_mapUpdatePageEventToState);
    on<UpdateRegisterRequestModelEvent>(
        _mapUpdateRegisterRequestModelEventToState);
    on<SendRegisterRequestEvent>(_mapSendRegisterEventToState);
  }

  final RegisterRepository registerRepo;

  void _mapGetDependenciesEventToState(
      GetDependenciesEvent event, Emitter<RegisterState> emit) async {
    emit(
      state.copyWith(
        status: RegisterStates.loading,
        isValid: state.isValid,
        currentPageIndex: state.currentPageIndex,
      ),
    );
    await registerRepo.getDependencies().then((result) {
      result.fold((l) {
        emit(
          state.copyWith(
            status: RegisterStates.failure,
            error: l,
            isValid: state.isValid,
            currentPageIndex: state.currentPageIndex,
          ),
        );
      }, (r) {
        emit(
          state.copyWith(
            status: RegisterStates.loaded,
            dependencies: r,
            isValid: state.isValid,
            currentPageIndex: state.currentPageIndex,
          ),
        );
      });
    });
  }

  void _mapUpdateIsValidFormEventToState(
      UpdateIsValidFormEvent event, Emitter<RegisterState> emit) {
    emit(
      state.copyWith(
          status: RegisterStates.loaded,
          isValid: event.isValid,
          dependencies: state.dependencies,
          registerRequestModel: state.registerRequestModel,
          formErrorMsg: event.formErrorMsg,
          currentPageIndex: state.currentPageIndex),
    );
  }

  void _mapUpdatePageEventToState(
      UpdatePageEvent event, Emitter<RegisterState> emit) {
    emit(
      state.copyWith(
          status: RegisterStates.loaded,
          dependencies: state.dependencies,
          isValid: state.isValid,
          registerRequestModel: state.registerRequestModel,
          currentPageIndex: event.newIndex),
    );
  }

  void _mapUpdateRegisterRequestModelEventToState(
      UpdateRegisterRequestModelEvent event, Emitter<RegisterState> emit) {
    emit(
      state.copyWith(
          status: RegisterStates.loaded,
          dependencies: state.dependencies,
          isValid: state.isValid,
          currentPageIndex: state.currentPageIndex,
          formErrorMsg: state.formErrorMsg,
          registerRequestModel: event.registerRequestModel),
    );
  }

  void _mapSendRegisterEventToState(
      SendRegisterRequestEvent event, Emitter<RegisterState> emit) async {
    emit(
      state.copyWith(
          status: RegisterStates.loading,
          dependencies: state.dependencies,
          isValid: state.isValid,
          currentPageIndex: state.currentPageIndex,
          formErrorMsg: state.formErrorMsg,
          registerRequestModel: state.registerRequestModel),
    );
    await registerRepo
        .sendRegisterRequest(body: state.registerRequestModel!)
        .then((result) {
      result.fold((l) {
        emit(
          state.copyWith(
              status: RegisterStates.failure,
              error: l,
              dependencies: state.dependencies,
              currentPageIndex: state.currentPageIndex,
              registerRequestModel: state.registerRequestModel),
        );
      }, (r) {
        emit(
          state.copyWith(
              status: RegisterStates.registerSuccess, registerResponse: r),
        );
      });
    });
  }
}
