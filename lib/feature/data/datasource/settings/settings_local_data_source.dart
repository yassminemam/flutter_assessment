import "package:flutter_assessment/feature/data/model/settings/settings_model.dart";
import "package:shared_preferences/shared_preferences.dart";

abstract class SettingsLocalDataSource {
  Future<void> updateUserSettings({required SettingsModel settings});

  Future<SettingsModel> getUserSettings();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPref;

  SettingsLocalDataSourceImpl({
    required this.sharedPref,
  });

  @override
  Future<void> updateUserSettings({required SettingsModel settings}) async {
    await sharedPref.setBool('isLogin', settings.isLogin);
    await sharedPref.setString('authToken', "Bearer ${settings.authToken}");
  }

  @override
  Future<SettingsModel> getUserSettings() async {
    bool isLoginVal = (sharedPref.getBool("isLogin")) ?? false;
    String authTokenVal = (sharedPref.getString("authToken")) ?? "";
    return SettingsModel(isLogin: isLoginVal, authToken: authTokenVal);
  }
}
