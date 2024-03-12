import 'package:bloc/bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../domain/usecase/get_countries/get_countries.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.getCountries}) : super(const HomeState()) {
    on<UpdatePageEvent>(_mapUpdatePageEventToState);
    on<GetCountriesEvent>(_mapGetCountriesEventToState);
  }
  final GetCountries getCountries;

  void _mapUpdatePageEventToState(
      UpdatePageEvent event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
          status: HomeStates.success,
          currentPageIndex: event.newIndex),
    );
  }

  void _mapGetCountriesEventToState(
      GetCountriesEvent event, Emitter<HomeState> emit) async {
    emit(
      state.copyWith(
          status: HomeStates.loading,
          currentPageIndex: state.currentPageIndex),
    );
    await getCountries.call(NoParams()).then((result) {
      result.fold((l) {
        emit(
          state.copyWith(
            status: HomeStates.failure,
            error: l,
            currentPageIndex: state.currentPageIndex,
          ),
        );
      }, (r) {
        emit(
          state.copyWith(
            status: HomeStates.success,
            countries: r,
            currentPageIndex: state.currentPageIndex,
          ),
        );
      });
    });
  }
}
