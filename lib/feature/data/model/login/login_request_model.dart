class LoginRequestModel {
  String? password;
  String? email;

  LoginRequestModel({this.password, this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['password'] = password;
    data['email'] = email;
    return data;
  }
}
