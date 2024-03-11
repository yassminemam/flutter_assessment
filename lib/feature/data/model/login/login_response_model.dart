class LoginResponseModel {
  int? status;
  bool? success;
  Data? data;
  String? accessToken;

  LoginResponseModel({this.status, this.success, this.data, this.accessToken});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['access_token'] = this.accessToken;
    return data;
  }
}

class Data {
  int? id;
  String? firstName;
  String? lastName;
  String? about;
  List<Tags>? tags;
  List<String>? favoriteSocialMedia;
  int? salary;
  String? email;
  String? birthDate;
  int? gender;
  Type? type;
  String? avatar;

  Data(
      {this.id,
        this.firstName,
        this.lastName,
        this.about,
        this.tags,
        this.favoriteSocialMedia,
        this.salary,
        this.email,
        this.birthDate,
        this.gender,
        this.type,
        this.avatar});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    about = json['about'];
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(new Tags.fromJson(v));
      });
    }
    favoriteSocialMedia = json['favorite_social_media'].cast<String>();
    salary = json['salary'];
    email = json['email'];
    birthDate = json['birth_date'];
    gender = json['gender'];
    type = json['type'] != null ? new Type.fromJson(json['type']) : null;
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['about'] = this.about;
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    data['favorite_social_media'] = this.favoriteSocialMedia;
    data['salary'] = this.salary;
    data['email'] = this.email;
    data['birth_date'] = this.birthDate;
    data['gender'] = this.gender;
    if (this.type != null) {
      data['type'] = this.type!.toJson();
    }
    data['avatar'] = this.avatar;
    return data;
  }
}

class Tags {
  int? id;
  String? name;

  Tags({this.id, this.name});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Type {
  int? code;
  String? name;
  String? niceName;

  Type({this.code, this.name, this.niceName});

  Type.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    niceName = json['nice_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['nice_name'] = this.niceName;
    return data;
  }
}
