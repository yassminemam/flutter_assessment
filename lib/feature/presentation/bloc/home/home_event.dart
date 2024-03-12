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