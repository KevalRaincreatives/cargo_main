class NumberCheckModel {
  bool success;
  String details;

  NumberCheckModel({this.success, this.details});

  NumberCheckModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['details'] = this.details;
    return data;
  }
}