import 'package:bloc/bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../domain/usecase/get_countries/get_countries.dart';
import '../../../domain/usecase/get_services/get_services.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
      {required this.getCountries,
      required this.getServices,
      required this.getPopularServices})
      : super(const HomeState()) {
    on<UpdatePageEvent>(_mapUpdatePageEventToState);
    on<GetCountriesEvent>(_mapGetCountriesEventToState);
    on<GetServicesEvent>(_mapGetServicesEventToState);
    on<GetPopularServicesEvent>(_mapGetPopularServicesEventToState);
  }

  final GetCountries getCountries;
  final GetServices getServices;
  final GetPopularServices getPopularServices;

  void _mapUpdatePageEventToState(
      UpdatePageEvent event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
          status: HomeStates.success, currentPageIndex: event.newIndex),
    );
  }

  void _mapGetCountriesEventToState(
      GetCountriesEvent event, Emitter<HomeState> emit) async {
    emit(
      state.copyWith(
          status: HomeStates.loading, currentPageIndex: state.currentPageIndex),
    );
    await getCountries
        .call(ParamsGetCountries(pageIndex: event.newPageIndex))
        .then((result) {
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

  void _mapGetServicesEventToState(
      GetServicesEvent event, Emitter<HomeState> emit) async {
    emit(
      state.copyWith(
          status: HomeStates.loading,
          currentPageIndex: state.currentPageIndex,
          popularServices: state.popularServices,
          services: state.services,
          countries: state.countries),
    );
    await getServices.call(NoParams()).then((result) {
      result.fold((l) {
        emit(
          state.copyWith(
            status: HomeStates.failure,
            error: l,
            countries: state.countries,
            popularServices: state.popularServices,
            services: state.services,
            currentPageIndex: state.currentPageIndex,
          ),
        );
      }, (r) {
        emit(state.copyWith(
          status: HomeStates.success,
          services: r,
          countries: state.countries,
          popularServices: state.popularServices,
          currentPageIndex: state.currentPageIndex,
        ));
      });
    });
  }

  void _mapGetPopularServicesEventToState(
      GetPopularServicesEvent event, Emitter<HomeState> emit) async {
    emit(
      state.copyWith(
          status: HomeStates.loading,
          currentPageIndex: state.currentPageIndex,
          services: state.services,
          popularServices: state.popularServices,
          countries: state.countries),
    );
    await getPopularServices.call(NoParams()).then((result) {
      result.fold((l) {
        emit(
          state.copyWith(
            status: HomeStates.failure,
            error: l,
            popularServices: state.popularServices,
            services: state.services,
            countries: state.countries,
            currentPageIndex: state.currentPageIndex,
          ),
        );
      }, (r) {
        emit(state.copyWith(
          status: HomeStates.success,
          popularServices: r,
          services: state.services,
          countries: state.countries,
          currentPageIndex: state.currentPageIndex,
        ));
      });
    });
  }
}
