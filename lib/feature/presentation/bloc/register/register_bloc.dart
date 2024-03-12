import 'package:bloc/bloc.dart';
import 'package:flutter_assessment/feature/domain/usecase/send_register/send_register.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../domain/usecase/get_dependencies/get_dependencies.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required this.getDependencies,
    required this.sendRegister,
  }) : super(const RegisterState()) {
    on<GetDependenciesEvent>(_mapGetDependenciesEventToState);
    on<UpdateIsValidFormEvent>(_mapUpdateIsValidFormEventToState);
    on<UpdateRegisterPageEvent>(_mapUpdatePageEventToState);
    on<UpdateRegisterRequestModelEvent>(
        _mapUpdateRegisterRequestModelEventToState);
    on<SendRegisterRequestEvent>(_mapSendRegisterEventToState);
  }

  final GetDependencies getDependencies;
  final SendRegister sendRegister;

  void _mapGetDependenciesEventToState(
      GetDependenciesEvent event, Emitter<RegisterState> emit) async {
    emit(
      state.copyWith(
        status: RegisterStates.loading,
        isValid: state.isValid,
        currentPageIndex: state.currentPageIndex,
      ),
    );
    await getDependencies.call(NoParams()).then((result) {
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
      UpdateRegisterPageEvent event, Emitter<RegisterState> emit) {
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
    await sendRegister
        .call(ParamsSendRegister(body: state.registerRequestModel!))
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
              status: RegisterStates.registerSuccess,
              registerResponse: r,
              dependencies: state.dependencies),
        );
        emit(
          state.copyWith(
              status: RegisterStates.initial, dependencies: state.dependencies),
        );
      });
    });
  }
}
