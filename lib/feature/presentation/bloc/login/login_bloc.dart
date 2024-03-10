import 'package:bloc/bloc.dart';
import '../../../domain/repository/dependencies/register_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {}
}
