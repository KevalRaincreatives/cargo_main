class OrderModel {
  bool success;
  List<OrderResponse> response;

  OrderModel({this.success, this.response});

  OrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      response = new List<OrderResponse>();
      json['response'].forEach((v) {
        response.add(new OrderResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.response != null) {
      data['response'] = this.response.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderResponse {
  String quoteId;
  String shipment_order_id;
  String deliveryDate;
  String quoteStatus;

  OrderResponse({this.quoteId,this.shipment_order_id, this.deliveryDate, this.quoteStatus});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    quoteId = json['quote_id'];
    shipment_order_id= json['shipment_order_id'];
    deliveryDate = json['delivery_date'];
    quoteStatus = json['quote_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quote_id'] = this.quoteId;
    data['shipment_order_id'] = this.shipment_order_id;
    data['delivery_date'] = this.deliveryDate;
    data['quote_status'] = this.quoteStatus;
    return data;
  }
}