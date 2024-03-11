import 'package:bloc/bloc.dart';
import '../../../domain/repository/login/login_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState());
}
