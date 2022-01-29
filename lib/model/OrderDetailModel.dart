import 'package:flutter_downloader/flutter_downloader.dart';

class OrderDetailModel {
  bool success;
  Details details;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  OrderDetailModel({this.success, this.details});

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
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
  String signature;
  List<Invoices> invoices;
  List<Items> items;
  String shipment_order_id;
  String shipmentId;
  String date;
  String estimatedDate;
  String deliveryMethod;
  String deliveryAddress;
  String status;

  Details(
      {this.signature,
        this.invoices,
        this.items,
        this.shipment_order_id,
        this.shipmentId,
        this.date,
        this.estimatedDate,
        this.deliveryMethod,
        this.deliveryAddress,
        this.status});

  Details.fromJson(Map<String, dynamic> json) {
    signature = json['signature'];
    if (json['invoices'] != null) {
      invoices = new List<Invoices>();
      json['invoices'].forEach((v) {
        invoices.add(new Invoices.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    shipment_order_id= json['shipment_order_id'];
    shipmentId = json['shipment_id'];
    date = json['date'];
    estimatedDate = json['estimated_date'];
    deliveryMethod = json['delivery_method'];
    deliveryAddress = json['delivery_address'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['signature'] = this.signature;
    if (this.invoices != null) {
      data['invoices'] = this.invoices.map((v) => v.toJson()).toList();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }

    data['shipment_order_id'] = this.shipment_order_id;
    data['shipment_id'] = this.shipmentId;
    data['date'] = this.date;
    data['estimated_date'] = this.estimatedDate;
    data['delivery_method'] = this.deliveryMethod;
    data['delivery_address'] = this.deliveryAddress;
    data['status'] = this.status;
    return data;
  }
}

class Invoices {
  String invoice;
  int invoiceId;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  Invoices({this.invoice, this.invoiceId});

  Invoices.fromJson(Map<String, dynamic> json) {
    invoice = json['invoice'];
    invoiceId = json['invoice_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoice'] = this.invoice;
    data['invoice_id'] = this.invoiceId;
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
