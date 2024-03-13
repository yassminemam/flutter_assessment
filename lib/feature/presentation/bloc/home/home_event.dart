import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class UpdatePageEvent extends HomeEvent {
  final int newIndex;

  const UpdatePageEvent({required this.newIndex});

  @override
  List<Object?> get props => [newIndex];
}

class GetCountriesEvent extends HomeEvent {
  const GetCountriesEvent({this.newPageIndex});

  final int? newPageIndex;

  @override
  List<Object?> get props => [newPageIndex];
}

class GetServicesEvent extends HomeEvent {
  const GetServicesEvent({required this.isPopular});

  final bool isPopular;

  @override
  List<Object> get props => [isPopular];
}
