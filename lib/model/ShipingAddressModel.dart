
class ShippingAddressModel {
  final List<ShippingHModel> data;

  ShippingAddressModel({this.data});

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    print(list.runtimeType);
    List<ShippingHModel> imagesList =
        list.map((i) => ShippingHModel.fromJson(i)).toList();

    return ShippingAddressModel(data: imagesList);
  }
}

class ShippingHModel {
  String id;
  String firstname;
  String lastname;
  String email;
  String telephone;
  String fax;
  String company;
  String company_id;
  String address_1;
  String address_2;
  String city;
  String postcode;
  String country_id;
  String zone_id;
  String created_date;

  ShippingHModel(
      {this.id,this.firstname,
      this.lastname,
      this.email,
      this.telephone,
      this.fax,
      this.company,
      this.company_id,
      this.address_1,
        this.address_2,
        this.city,
        this.postcode,
        this.country_id,
        this.zone_id,
        this.created_date});

  factory ShippingHModel.fromJson(Map<String, dynamic> json) {
    return ShippingHModel(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        email: json['email'],
        telephone: json['telephone'],
        fax: json['fax'],
        company: json['company'],
        company_id: json['company_id'],
        address_1: json['address_1'],
        address_2: json['address_2'],
        city: json['city'],
        postcode: json['postcode'],
        country_id: json['country_id'],
        zone_id: json['zone_id'],
        created_date: json['created_date']);
  }
}
