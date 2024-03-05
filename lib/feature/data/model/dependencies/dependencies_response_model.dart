class DependenciesResponseModel {
  int? status;
  bool? success;
  Data? data;

  DependenciesResponseModel({this.status, this.success, this.data});

  DependenciesResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Type>? types;
  List<Tag>? tags;
  List<SocialMedia>? socialMedia;

  Data({this.types, this.tags, this.socialMedia});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['types'] != null) {
      types = <Type>[];
      json['types'].forEach((v) {
        types!.add(new Type.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      tags = <Tag>[];
      json['tags'].forEach((v) {
        tags!.add(new Tag.fromJson(v));
      });
    }
    if (json['social_media'] != null) {
      socialMedia = <SocialMedia>[];
      json['social_media'].forEach((v) {
        socialMedia!.add(new SocialMedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.types != null) {
      data['types'] = this.types!.map((v) => v.toJson()).toList();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    if (this.socialMedia != null) {
      data['social_media'] = this.socialMedia!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Type {
  int? value;
  String? label;

  Type({this.value, this.label});

  Type.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['label'] = this.label;
    return data;
  }
}

class SocialMedia {
  String? value;
  String? label;

  SocialMedia({this.value, this.label});

  SocialMedia.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['label'] = this.label;
    return data;
  }
}

class Tag {
  int? value;
  String? label;

  Tag({this.value, this.label});

  Tag.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['label'] = this.label;
    return data;
  }
}
