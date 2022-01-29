class OrderUpdateModel {
  bool success;
  List<Invoices2> invoices;

  OrderUpdateModel({this.success, this.invoices});

  OrderUpdateModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['invoices'] != null) {
      invoices = new List<Invoices2>();
      json['invoices'].forEach((v) {
        invoices.add(new Invoices2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.invoices != null) {
      data['invoices'] = this.invoices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Invoices2 {
  String file;
  String url;
  String type;

  Invoices2({this.file, this.url, this.type});

  Invoices2.fromJson(Map<String, dynamic> json) {
    file = json['file'];
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file'] = this.file;
    data['url'] = this.url;
    data['type'] = this.type;
    return data;
  }
}