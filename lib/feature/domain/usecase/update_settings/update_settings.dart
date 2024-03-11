import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../data/model/settings/settings_model.dart';
import '../../repository/settings/settings_repository.dart';

class UpdateSettings implements UseCase<void, ParamsUpdateSettings> {
  final SettingsRepository settingsRepo;

  UpdateSettings({required this.settingsRepo});

  @override
  Future<Either<Failure, void>> call(ParamsUpdateSettings params) async {
    return await settingsRepo.updateSettings(settingsModel: params.settings);
  }

}
class ParamsUpdateSettings extends Equatable {
  final SettingsModel settings;

  const ParamsUpdateSettings({required this.settings});

  @override
  List<Object> get props => [settings];

  @override
  String toString() {
    return 'ParamsUpdateSettings{settings: ${settings.toJson()}';
  }
}