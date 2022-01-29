class Contact2Model {
  bool success;
  Data data;
  Data dataAddress;

  Contact2Model({this.success, this.data, this.dataAddress});

  Contact2Model.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    dataAddress = json['data_address'] != null
        ? new Data.fromJson(json['data_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    if (this.dataAddress != null) {
      data['data_address'] = this.dataAddress.toJson();
    }
    return data;
  }
}

class Data {
  String address1;
  String address2;
  String address3;
  String phone;
  String email;
  String latitude;
  String longitude;

  Data(
      {this.address1,
        this.address2,
        this.address3,
        this.phone,
        this.email,
        this.latitude,
        this.longitude});

  Data.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    phone = json['phone'];
    email = json['email'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['address3'] = this.address3;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}