import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../data/model/settings/settings_model.dart';

abstract class SettingsRepository {
  Future<Either<Failure, void>> updateSettings(
      {required SettingsModel settingsModel});
  Future<Either<Failure, SettingsModel>> getSetting();
}
