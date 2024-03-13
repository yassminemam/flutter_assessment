class ServicesResponseModel {
  int? status;
  bool? success;
  List<Service>? data;

  ServicesResponseModel({this.status, this.success, this.data});

  ServicesResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      data = <Service>[];
      json['data'].forEach((v) {
        data!.add(new Service.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Service {
  int? id;
  String? mainImage;
  int? price;
  dynamic discount;
  int? priceAfterDiscount;
  String? title;
  int? averageRating;
  int? completedSalesCount;
  bool? recommended;

  Service(
      {this.id,
        this.mainImage,
        this.price,
        this.discount,
        this.priceAfterDiscount,
        this.title,
        this.averageRating,
        this.completedSalesCount,
        this.recommended});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainImage = json['main_image'];
    price = json['price'];
    discount = json['discount'];
    priceAfterDiscount = json['price_after_discount'];
    title = json['title'];
    averageRating = json['average_rating'];
    completedSalesCount = json['completed_sales_count'];
    recommended = json['recommended'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['main_image'] = this.mainImage;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['price_after_discount'] = this.priceAfterDiscount;
    data['title'] = this.title;
    data['average_rating'] = this.averageRating;
    data['completed_sales_count'] = this.completedSalesCount;
    data['recommended'] = this.recommended;
    return data;
  }
}
