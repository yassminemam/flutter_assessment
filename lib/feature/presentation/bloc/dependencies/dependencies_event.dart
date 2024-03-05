import 'package:equatable/equatable.dart';

abstract class DependenciesEvent extends Equatable {
  const DependenciesEvent();
}

class GetDependenciesEvent extends DependenciesEvent {
  const GetDependenciesEvent();

  @override
  List<Object> get props => [];

}