import 'dart:ffi';



class QuoteSuccessModel {
  bool success;
  RequestModel request;
  int quote_id;


  QuoteSuccessModel({this.success,this.request,this.quote_id});

  QuoteSuccessModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    request = json['request'] != null ? new RequestModel.fromJson(json['request']) : null;
    quote_id= json['quote_id'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.request != null) {
      data['request'] = this.request.toJson();
    }
    data['quote_id'] = this.quote_id;
    return data;
  }
}


class RequestModel {
  List<Items> items;

  RequestModel({this.items});

  RequestModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Items {
  dynamic packageType;
  dynamic width;
  dynamic height;
  dynamic length;
  dynamic weight;
  dynamic itemType;
  dynamic price;

  Items(
      {this.packageType,
        this.width,
        this.height,
        this.length,
        this.weight,
        this.itemType,
        this.price});

  Items.fromJson(Map<String, dynamic> json) {
    packageType = json['package_type'];
    width = json['width'];
    height = json['height'];
    length = json['length'];
    weight = json['weight'];
    itemType = json['item_type'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['package_type'] = this.packageType;
    data['width'] = this.width;
    data['height'] = this.height;
    data['length'] = this.length;
    data['weight'] = this.weight;
    data['item_type'] = this.itemType;
    data['price'] = this.price;
    return data;
  }
}

