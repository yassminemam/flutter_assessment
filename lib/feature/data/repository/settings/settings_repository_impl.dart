import 'package:dartz/dartz.dart';
import 'package:flutter_assessment/feature/data/model/settings/settings_model.dart';
import '../../../../core/error/failure.dart';
import '../../../domain/repository/settings/settings_repository.dart';
import '../../datasource/settings/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource? settingsLocalDataSource;

  SettingsRepositoryImpl({
    required this.settingsLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> updateSettings(
      {required SettingsModel settingsModel}) async {
    if (settingsLocalDataSource != null) {
      return Right(await settingsLocalDataSource!
          .updateUserSettings(settings: settingsModel));
    } else {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, SettingsModel>> getSetting() async {
    if (settingsLocalDataSource != null) {
      return Right(await settingsLocalDataSource!.getUserSettings());
    } else {
    return Left(CacheFailure());
    }

  }
}
