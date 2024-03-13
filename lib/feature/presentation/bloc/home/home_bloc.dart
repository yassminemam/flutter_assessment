import 'package:bloc/bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../domain/usecase/get_countries/get_countries.dart';
import '../../../domain/usecase/get_services/get_services.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.getCountries, required this.getServices})
      : super(const HomeState()) {
    on<UpdatePageEvent>(_mapUpdatePageEventToState);
    on<GetCountriesEvent>(_mapGetCountriesEventToState);
    on<GetServicesEvent>(_mapGetServicesEventToState);
  }

  final GetCountries getCountries;
  final GetServices getServices;

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
          countries: state.countries),
    );
    await getServices
        .call(ParamsGetServices(isPopular: event.isPopular))
        .then((result) {
      result.fold((l) {
        emit(
          state.copyWith(
            status: HomeStates.failure,
            error: l,
            countries: state.countries,
            currentPageIndex: state.currentPageIndex,
          ),
        );
      }, (r) {
        if (!event.isPopular) {
          emit(state.copyWith(
            status: HomeStates.success,
            services: r,
            countries: state.countries,
            currentPageIndex: state.currentPageIndex,
          ));
        } else {
          emit(state.copyWith(
            status: HomeStates.success,
            popularServices: r,
            services: state.services,
            countries: state.countries,
            currentPageIndex: state.currentPageIndex,
          ));
        }
      });
    });
  }
}
