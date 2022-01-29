class CountryParishModel {
  List<Countries> countries;

  CountryParishModel({this.countries});

  CountryParishModel.fromJson(Map<String, dynamic> json) {
    if (json['countries'] != null) {
      countries = new List<Countries>();
      json['countries'].forEach((v) {
        countries.add(new Countries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.countries != null) {
      data['countries'] = this.countries.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Countries {
  String country;
  List<Parishes> parishes;

  Countries({this.country, this.parishes});

  Countries.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    if (json['parishes'] != null) {
      parishes = new List<Parishes>();
      json['parishes'].forEach((v) {
        parishes.add(new Parishes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    if (this.parishes != null) {
      data['parishes'] = this.parishes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parishes {
  String id;
  String name;
  String country;
  Null createdAt;
  String updatedAt;

  Parishes({this.id, this.name, this.country, this.createdAt, this.updatedAt});

  Parishes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    country = json['country'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country'] = this.country;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}