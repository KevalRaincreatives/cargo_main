class ViewCodeModel {
  String country_code;

  ViewCodeModel({this.country_code});

  ViewCodeModel.fromJson(Map<String, dynamic> json) {
    country_code = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_code'] = this.country_code;
    return data;
  }
}