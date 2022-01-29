class AddressListModel {
  bool success;
  List<Data> data;

  AddressListModel({this.success, this.data});

  AddressListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String shippingAddressNickname;
  String shippingFirstName;
  String shippingLastName;
  String shippingCompany;
  String shippingCountry;
  String shippingAddress1;
  String shippingAddress2;
  String shippingCity;
  String shippingState;
  String shippingPostcode;
  String name;
  String shipping_country_code;

  Data(
      {this.shippingAddressNickname,
        this.shippingFirstName,
        this.shippingLastName,
        this.shippingCompany,
        this.shippingCountry,
        this.shippingAddress1,
        this.shippingAddress2,
        this.shippingCity,
        this.shippingState,
        this.shippingPostcode,
        this.name,
      this.shipping_country_code});

  Data.fromJson(Map<String, dynamic> json) {
    shippingAddressNickname = json['shipping_address_nickname'];
    shippingFirstName = json['shipping_first_name'];
    shippingLastName = json['shipping_last_name'];
    shippingCompany = json['shipping_company'];
    shippingCountry = json['shipping_country'];
    shippingAddress1 = json['shipping_address_1'];
    shippingAddress2 = json['shipping_address_2'];
    shippingCity = json['shipping_city'];
    shippingState = json['shipping_state'];
    shippingPostcode = json['shipping_postcode'];
    name = json['name'];
    shipping_country_code=json['shipping_country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shipping_address_nickname'] = this.shippingAddressNickname;
    data['shipping_first_name'] = this.shippingFirstName;
    data['shipping_last_name'] = this.shippingLastName;
    data['shipping_company'] = this.shippingCompany;
    data['shipping_country'] = this.shippingCountry;
    data['shipping_address_1'] = this.shippingAddress1;
    data['shipping_address_2'] = this.shippingAddress2;
    data['shipping_city'] = this.shippingCity;
    data['shipping_state'] = this.shippingState;
    data['shipping_postcode'] = this.shippingPostcode;
    data['name'] = this.name;
    data['shipping_country_code']=this.shipping_country_code;
    return data;
  }
}