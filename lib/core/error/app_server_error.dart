class AppServerError {
  String? message;
  dynamic errors;

  AppServerError({this.message, this.errors});

  static AppServerError? fromJson(Map<String, dynamic> json) {
    try {
      return AppServerError(message: json['message'], errors: json['errors']?.toString());
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return "$message: ${errors.toString()}";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = message;
    if (errors != null) {
      data['errors'] = errors!.toJson();
    }
    return data;
  }
}
