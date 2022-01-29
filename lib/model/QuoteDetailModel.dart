class QuoteDetailModel {
  bool success;
  Details details;

  QuoteDetailModel({this.success, this.details});

  QuoteDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.details != null) {
      data['details'] = this.details.toJson();
    }
    return data;
  }
}

class Details {
  List<Items> items;
  String grandTotal;
  String quoteId;
  String date;
  String status;

  Details({this.items, this.grandTotal, this.quoteId, this.date, this.status});

  Details.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    grandTotal = json['grand_total'];
    quoteId = json['quote_id'];
    date = json['date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['grand_total'] = this.grandTotal;
    data['quote_id'] = this.quoteId;
    data['date'] = this.date;
    data['status'] = this.status;
    return data;
  }
}

class Items {
  String packageType;
  String width;
  String height;
  String length;
  String weight;
  String itemType;
  String price;
  String freight;
  String vat;
  String duty;
  String total;

  Items(
      {this.packageType,
        this.width,
        this.height,
        this.length,
        this.weight,
        this.itemType,
        this.price,
        this.freight,
        this.vat,
        this.duty,
        this.total});

  Items.fromJson(Map<String, dynamic> json) {
    packageType = json['package_type'];
    width = json['width'];
    height = json['height'];
    length = json['length'];
    weight = json['weight'];
    itemType = json['item_type'];
    price = json['price'];
    freight = json['freight'];
    vat = json['vat'];
    duty = json['duty'];
    total = json['total'];
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
    data['freight'] = this.freight;
    data['vat'] = this.vat;
    data['duty'] = this.duty;
    data['total'] = this.total;
    return data;
  }
}