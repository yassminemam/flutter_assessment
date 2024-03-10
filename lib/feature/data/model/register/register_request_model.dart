class RegisterRequestModel {
  String? firstName;
  String? lastName;
  String? about;
  List<num?>? tags;
  List<String>? favSocialMedia;
  num? salary;
  String? password;
  String? passwordConf;
  String? email;
  String? birthDate;
  int? gender;
  int? type;
  dynamic avatar;

  RegisterRequestModel(
      {this.firstName,
      this.lastName,
      this.about,
      this.tags,
      this.favSocialMedia,
      this.salary,
      this.password,
      this.passwordConf,
      this.email,
      this.birthDate,
      this.gender,
      this.type,
      this.avatar});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['about'] = about;
    data['tags'] = tags;
    data['favorite_social_media'] = favSocialMedia;
    data['salary'] = salary;
    data['password'] = password;
    data['email'] = email;
    data['birth_date'] = birthDate;
    if (gender != null) {
      data['gender'] = gender;
    }
    data['type'] = type;
    if (avatar != null) {
      data['avatar'] = avatar;
    }
    data['password_confirmation'] = passwordConf;
    return data;
  }
}
