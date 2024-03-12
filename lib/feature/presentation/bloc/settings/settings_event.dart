import 'package:equatable/equatable.dart';
import '../../../data/model/settings/settings_model.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class UpdateSessionEvent extends SettingsEvent {
  final SettingsModel settingsModel;

  const UpdateSessionEvent({required this.settingsModel});

  @override
  List<Object?> get props => [settingsModel];
}

class GetSessionEvent extends SettingsEvent {
  const GetSessionEvent();

  @override
  List<Object?> get props => [];
}
