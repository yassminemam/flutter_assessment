import 'package:equatable/equatable.dart';
import '../../../data/model/settings/settings_model.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class UpdateSettingsEvent extends SettingsEvent {
  final SettingsModel settingsModel;

  const UpdateSettingsEvent({required this.settingsModel});

  @override
  List<Object?> get props => [settingsModel];
}

class GetSettingsEvent extends SettingsEvent {
  const GetSettingsEvent();

  @override
  List<Object?> get props => [];
}
