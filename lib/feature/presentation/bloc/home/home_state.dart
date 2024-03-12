import 'package:equatable/equatable.dart';
import 'package:flutter_assessment/feature/data/model/home/countries_response_model.dart';
import 'package:flutter_assessment/feature/data/model/login/login_request_model.dart';
import '../../../../core/error/failure.dart';

enum HomeStates { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState(
      {this.status = HomeStates.initial,
      this.error,
      this.currentPageIndex,
      this.countries});

  final HomeStates status;
  final Failure? error;
  final int? currentPageIndex;
  final CountriesResponseModel? countries;

  @override
  List<Object?> get props => [status, error, currentPageIndex];

  HomeState copyWith(
      {required HomeStates status,
      Failure? error,
      LoginRequestModel? body,
      int? currentPageIndex,
      CountriesResponseModel? countries}) {
    return HomeState(
        status: status,
        error: error ?? ConnectionFailure(),
        countries: countries,
        currentPageIndex: currentPageIndex);
  }
}
