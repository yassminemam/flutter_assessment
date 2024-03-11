class SettingsModel {
  String authToken = '';
  bool isLogin = false;

  SettingsModel({required this.authToken, required this.isLogin});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["authToken"] = authToken;
    data["isLogin"] = isLogin;
    return data;
  }
}
