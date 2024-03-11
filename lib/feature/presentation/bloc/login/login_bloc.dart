import 'package:bloc/bloc.dart';
import '../../../domain/repository/login/login_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.loginRepo}) : super(const LoginState()) {
    on<LoginUserEvent>(_mapLoginUserEventToState);
  }

  final LoginRepository loginRepo;

  void _mapLoginUserEventToState(
      LoginUserEvent event, Emitter<LoginState> emit) async {
    emit(
      state.copyWith(
        status: LoginStates.loading,
        body: event.body,
      ),
    );
    await loginRepo.login(body: event.body).then((result) {
      result.fold((l) {
        emit(
          state.copyWith(
            status: LoginStates.failure,
            error: l,
            body: event.body,
          ),
        );
      }, (r) {
        emit(
          state.copyWith(
            status: LoginStates.loaded,
            loginResponse: r,
          ),
        );
      });
    });
  }
}
