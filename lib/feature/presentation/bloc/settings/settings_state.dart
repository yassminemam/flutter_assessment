import 'package:equatable/equatable.dart';import 'package:flutter_assessment/feature/data/model/settings/settings_model.dart';
import '../../../../core/error/failure.dart';

enum SettingsStates { initial, loading, failure, success }
class SettingsState extends Equatable {
  const SettingsState({
    this.status = SettingsStates.initial,
    this.error,
    this.settingsModel,
  });
  final SettingsStates status;
  final Failure? error;
  final SettingsModel? settingsModel;

  @override
  List<Object?> get props => [status, settingsModel, error];

  SettingsState copyWith({
    required SettingsStates status,
    Failure? error,
    SettingsModel? settingsModel
  }) {
    return SettingsState(
        status: status,
        settingsModel: settingsModel,
        error: error ?? CacheFailure()
    );
  }
}