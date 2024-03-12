import 'package:bloc/bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<UpdatePageEvent>(_mapUpdatePageEventToState);
  }
  void _mapUpdatePageEventToState(
      UpdatePageEvent event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
          status: HomeStates.success,
          currentPageIndex: event.newIndex),
    );
  }
}
