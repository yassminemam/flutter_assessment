import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../data/model/settings/settings_model.dart';
import '../../repository/settings/settings_repository.dart';

class GetSettings implements UseCase<SettingsModel, NoParams> {
  final SettingsRepository settingsRepo;

  GetSettings({required this.settingsRepo});

  @override
  Future<Either<Failure, SettingsModel>> call(NoParams params) async {
    return await settingsRepo.getSetting();
  }

}