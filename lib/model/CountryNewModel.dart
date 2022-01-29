class CountryNewModel {
  List<Countries> countries;

  CountryNewModel({this.countries});

  CountryNewModel.fromJson(Map<String, dynamic> json) {
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
  String code;
  String name;


  Countries({this.code, this.name});

  Countries.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;

    return data;
  }
}

