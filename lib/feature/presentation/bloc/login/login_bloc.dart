import 'package:bloc/bloc.dart';
import '../../../domain/usecase/login_user/login_user.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.loginUser}) : super(const LoginState()) {
    on<LoginUserEvent>(_mapLoginUserEventToState);
  }

  final LoginUser loginUser;

  void _mapLoginUserEventToState(
      LoginUserEvent event, Emitter<LoginState> emit) async {
    emit(
      state.copyWith(
        status: LoginStates.loading,
        body: event.body,
      ),
    );
    await loginUser.call(ParamsLoginUser(body: event.body)).then((result) {
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
